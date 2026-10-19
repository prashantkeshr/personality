package com.dhurta.personality

import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.StatFs
import android.Manifest
import androidx.activity.result.ActivityResultLauncher
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.health.connect.client.PermissionController
import androidx.lifecycle.lifecycleScope
import com.dhurta.personality.sensors.HealthConnectBridge
import com.dhurta.personality.sensors.MotionTracker
import com.dhurta.personality.sensors.SensorStore
import com.dhurta.personality.sensors.StepSampler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterFragmentActivity() {
    private var permissionResult: MethodChannel.Result? = null
    private var cameraResult: MethodChannel.Result? = null
    private var hcResult: MethodChannel.Result? = null
    private lateinit var hcLauncher: ActivityResultLauncher<Set<String>>
    private var pendingWidgetAction: String? = null

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        takeWidgetAction(intent)
    }

    override fun onNewIntent(intent: android.content.Intent) {
        super.onNewIntent(intent)
        takeWidgetAction(intent)
    }

    private fun takeWidgetAction(intent: android.content.Intent?) {
        if (intent?.action == TodayWidget.ACTION_ADD_WATER) pendingWidgetAction = "add_water"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        hcLauncher = registerForActivityResult(
            PermissionController.createRequestPermissionResultContract()
        ) { granted ->
            hcResult?.success(granted.toList())
            hcResult = null
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/sensors")
            .setMethodCallHandler { call, result -> onSensors(call.method, call.arguments, result) }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/widget")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "update" -> {
                        TodayWidget.save(applicationContext, call.arguments as Map<*, *>)
                        result.success(null)
                    }
                    // A tap on the widget's "+ glass" button, handled once.
                    "takeAction" -> {
                        result.success(pendingWidgetAction)
                        pendingWidgetAction = null
                    }
                    else -> result.notImplemented()
                }
            }
        val files = FileChannel(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/files")
            .setMethodCallHandler { call, result -> files.handle(call, result) }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "probe") {
                    result.success(probe())
                } else if (call.method == "playSound") {
                    playSound(call.argument<String>("name") ?: "system")
                    result.success(null)
                } else if (call.method == "network") {
                    result.success(network())
                } else if (call.method == "permissions") {
                    result.success(permissions())
                } else if (call.method == "requestCamera") {
                    requestCamera(result)
                } else if (call.method == "markAsked") {
                    when (call.argument<String>("permission")) {
                        "notifications" -> if (Build.VERSION.SDK_INT >= 33)
                            markAsked(Manifest.permission.POST_NOTIFICATIONS)
                        "activity" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
                            markAsked(Manifest.permission.ACTIVITY_RECOGNITION)
                    }
                    result.success(null)
                } else if (call.method == "openAppSettings") {
                    openAppSettings()
                    result.success(null)
                } else if (call.method == "email") {
                    result.success(email(call.argument<String>("to")!!, call.argument<String>("subject") ?: ""))
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun granted(p: String) =
        ContextCompat.checkSelfPermission(this, p) == PackageManager.PERMISSION_GRANTED

    /**
     * What the app may use now, and for each missing one whether Android will
     * still show its prompt (false after repeated refusals: then only the
     * app's settings page can turn it on).
     */
    private fun permissions(): Map<String, Any> {
        val notifications = if (Build.VERSION.SDK_INT >= 33)
            granted(Manifest.permission.POST_NOTIFICATIONS)
        else androidx.core.app.NotificationManagerCompat.from(this).areNotificationsEnabled()
        fun askable(p: String) = !granted(p) &&
            (!asked(p) || ActivityCompat.shouldShowRequestPermissionRationale(this, p))
        return mapOf(
            "notifications" to notifications,
            "camera" to granted(Manifest.permission.CAMERA),
            "activity" to activityGranted(),
            "cameraAskable" to askable(Manifest.permission.CAMERA),
            "activityAskable" to (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q &&
                askable(Manifest.permission.ACTIVITY_RECOGNITION)),
            "notificationsAskable" to (Build.VERSION.SDK_INT >= 33 &&
                askable(Manifest.permission.POST_NOTIFICATIONS)),
        )
    }

    // Android can't tell "never asked" from "refused for good"; remember asks.
    private val asks by lazy { getSharedPreferences("permission_asks", MODE_PRIVATE) }
    private fun asked(p: String) = asks.getBoolean(p, false)
    private fun markAsked(p: String) = asks.edit().putBoolean(p, true).apply()

    private fun requestCamera(result: MethodChannel.Result) {
        if (granted(Manifest.permission.CAMERA)) {
            result.success(true)
            return
        }
        cameraResult = result
        markAsked(Manifest.permission.CAMERA)
        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), 42)
    }

    private fun openAppSettings() {
        startActivity(
            android.content.Intent(
                android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                android.net.Uri.fromParts("package", packageName, null),
            ).addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
        )
    }

    /** Opens the user's own mail app with a new message; false if there is none. */
    private fun email(to: String, subject: String): Boolean = try {
        startActivity(
            android.content.Intent(android.content.Intent.ACTION_SENDTO, android.net.Uri.parse("mailto:")).apply {
                putExtra(android.content.Intent.EXTRA_EMAIL, arrayOf(to))
                putExtra(android.content.Intent.EXTRA_SUBJECT, subject)
            }
        )
        true
    } catch (e: android.content.ActivityNotFoundException) {
        false
    }

    private fun activityGranted() = Build.VERSION.SDK_INT < Build.VERSION_CODES.Q ||
        ContextCompat.checkSelfPermission(this, Manifest.permission.ACTIVITY_RECOGNITION) ==
            PackageManager.PERMISSION_GRANTED

    /** On-device sensors and Health Connect. Nothing here uses the network. */
    private fun onSensors(method: String, args: Any?, result: MethodChannel.Result) {
        val ctx = applicationContext
        when (method) {
            "status" -> lifecycleScope.launch {
                val hc = HealthConnectBridge.status(ctx)
                val granted = if (hc == "available")
                    runCatching { HealthConnectBridge.granted(ctx).toList() }.getOrDefault(emptyList())
                else emptyList()
                result.success(mapOf(
                    "stepSensor" to StepSampler.hasSensor(ctx),
                    "activityPermission" to activityGranted(),
                    "playServices" to MotionTracker.playServicesAvailable(ctx),
                    "healthConnect" to hc,
                    "hcGranted" to granted,
                ))
            }
            "requestActivityPermission" -> {
                if (activityGranted()) {
                    result.success(true)
                } else {
                    permissionResult = result
                    ActivityCompat.requestPermissions(
                        this, arrayOf(Manifest.permission.ACTIVITY_RECOGNITION), 41)
                }
            }
            "configure" -> {
                val a = args as Map<*, *>
                val steps = a["steps"] == true
                val activity = a["activity"] == true
                val sleep = a["sleep"] == true
                SensorStore.setEnabled(ctx, "steps", steps)
                SensorStore.setEnabled(ctx, "activity", activity)
                SensorStore.setEnabled(ctx, "sleep", sleep)
                if (steps) StepSampler.schedule(ctx) else StepSampler.cancel(ctx)
                MotionTracker.stop(ctx)
                if ((activity || sleep) && activityGranted() &&
                    MotionTracker.playServicesAvailable(ctx)) {
                    runCatching { MotionTracker.start(ctx, activity, sleep) }
                }
                result.success(null)
            }
            "read" -> lifecycleScope.launch {
                val data = withContext(Dispatchers.IO) {
                    if (SensorStore.isEnabled(ctx, "steps") && activityGranted()) {
                        StepSampler.sample(ctx)
                    }
                    mapOf(
                        "steps" to SensorStore.read(ctx, SensorStore.STEPS),
                        "activity" to SensorStore.read(ctx, SensorStore.ACTIVITY),
                        "sleep" to SensorStore.read(ctx, SensorStore.SLEEP),
                    )
                }
                result.success(data)
            }
            "prune" -> {
                val before = (args as Number).toLong()
                for (k in listOf(SensorStore.STEPS, SensorStore.ACTIVITY, SensorStore.SLEEP)) {
                    SensorStore.prune(ctx, k, before)
                }
                result.success(null)
            }
            "clear" -> {
                SensorStore.clearAll(ctx)
                StepSampler.cancel(ctx)
                MotionTracker.stop(ctx)
                result.success(null)
            }
            "hcRequest" -> {
                if (HealthConnectBridge.status(ctx) != "available") {
                    result.success(emptyList<String>())
                } else {
                    hcResult = result
                    hcLauncher.launch(HealthConnectBridge.permissions)
                }
            }
            "hcRead" -> lifecycleScope.launch {
                try {
                    val since = (args as Number).toLong()
                    val data = withContext(Dispatchers.IO) { HealthConnectBridge.read(ctx, since) }
                    result.success(data)
                } catch (e: Exception) {
                    result.error("hc", e.javaClass.simpleName, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 42) {
            cameraResult?.success(
                grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)
            cameraResult = null
        }
        if (requestCode == 41) {
            permissionResult?.success(
                grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)
            permissionResult = null
        }
    }

    /** Whether a download can start now, and whether it would use mobile data. */
    private var preview: android.media.MediaPlayer? = null

    /** Plays a reminder sound once, as a preview in Settings. */
    private fun playSound(name: String) {
        preview?.release()
        preview = null
        if (name == "silent") return
        val uri = if (name == "system") {
            android.media.RingtoneManager.getDefaultUri(android.media.RingtoneManager.TYPE_NOTIFICATION)
        } else {
            val id = resources.getIdentifier(name, "raw", packageName)
            if (id == 0) return
            android.net.Uri.parse("android.resource://$packageName/$id")
        } ?: return
        preview = try { android.media.MediaPlayer().apply {
            setAudioAttributes(
                android.media.AudioAttributes.Builder()
                    .setUsage(android.media.AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(android.media.AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
            )
            setDataSource(applicationContext, uri)
            setOnCompletionListener { it.release(); if (preview === it) preview = null }
            setOnPreparedListener { it.start() }
            prepareAsync()
        } } catch (e: Exception) {
            null // a preview is best-effort
        }
    }

    private fun network(): Map<String, Boolean> {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val caps = cm.getNetworkCapabilities(cm.activeNetwork)
        return mapOf(
            "online" to (caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true),
            "unmetered" to (caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_METERED) == true),
        )
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
