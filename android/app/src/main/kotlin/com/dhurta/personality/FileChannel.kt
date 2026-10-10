package com.dhurta.personality

import android.app.Activity
import android.content.Intent
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.FileProvider
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

/**
 * Moves the user's own exports in and out of the app through Android's
 * system pickers and share sheet. No storage permission and no network:
 * the user chooses every destination and every file.
 */
class FileChannel(private val activity: FragmentActivity) {
    private var pending: MethodChannel.Result? = null
    private var pendingBytes: ByteArray? = null
    private val launcher: ActivityResultLauncher<Intent> =
        activity.registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            onResult(it)
        }
    private var mode = ""

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (pending != null) {
            result.error("busy", "Another file request is open", null)
            return
        }
        when (call.method) {
            "save" -> {
                pending = result
                pendingBytes = call.argument<ByteArray>("bytes")
                mode = "save"
                launcher.launch(Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    type = call.argument<String>("mime")
                    putExtra(Intent.EXTRA_TITLE, call.argument<String>("name"))
                })
            }
            "open" -> {
                pending = result
                mode = "open"
                launcher.launch(Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    addCategory(Intent.CATEGORY_OPENABLE)
                    // Backups can arrive with any type (chat apps rename them).
                    type = "*/*"
                })
            }
            "share" -> activity.lifecycleScope.launch {
                try {
                    val name = call.argument<String>("name")!!
                    val file = withContext(Dispatchers.IO) {
                        val dir = File(activity.cacheDir, "share").apply {
                            deleteRecursively()
                            mkdirs()
                        }
                        File(dir, name).apply { writeBytes(call.argument<ByteArray>("bytes")!!) }
                    }
                    val uri = FileProvider.getUriForFile(
                        activity, "${activity.packageName}.files", file)
                    val send = Intent(Intent.ACTION_SEND).apply {
                        type = call.argument<String>("mime")
                        putExtra(Intent.EXTRA_STREAM, uri)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    activity.startActivity(Intent.createChooser(send, null))
                    result.success(true)
                } catch (e: Exception) {
                    result.error("share", e.javaClass.simpleName, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun onResult(r: ActivityResult) {
        val result = pending ?: return
        val bytes = pendingBytes
        pending = null
        pendingBytes = null
        val uri = r.data?.data
        if (r.resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null) // cancelled
            return
        }
        activity.lifecycleScope.launch {
            try {
                val out = withContext(Dispatchers.IO) {
                    val resolver = activity.contentResolver
                    if (mode == "save") {
                        resolver.openOutputStream(uri, "wt")!!.use { it.write(bytes!!) }
                        true
                    } else {
                        resolver.openInputStream(uri)!!.use { it.readBytes() }
                    }
                }
                result.success(out)
            } catch (e: Exception) {
                result.error("io", e.javaClass.simpleName, null)
            }
        }
    }
}
