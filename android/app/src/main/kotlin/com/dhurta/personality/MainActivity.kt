package com.dhurta.personality

import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "probe") {
                    result.success(probe())
                } else {
                    result.notImplemented()
                }
            }
    }

    /** Hardware facts used to pick processing quality. No identifiers. */
    private fun probe(): Map<String, Any> {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val mem = ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }
        val stat = StatFs(filesDir.absolutePath)
        val pm = packageManager
        return mapOf(
            "ramMb" to (mem.totalMem / (1024 * 1024)).toInt(),
            "cpuCores" to Runtime.getRuntime().availableProcessors(),
            "osApiLevel" to Build.VERSION.SDK_INT,
            "freeStorageMb" to (stat.availableBytes / (1024 * 1024)).toInt(),
            "lowRamDevice" to am.isLowRamDevice,
            "hasCamera" to pm.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY),
            "hasFrontCamera" to pm.hasSystemFeature(PackageManager.FEATURE_CAMERA_FRONT),
        )
    }
}
