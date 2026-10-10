package com.dhurta.personality

import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
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
    private var hcResult: MethodChannel.Result? = null
    private lateinit var hcLauncher: ActivityResultLauncher<Set<String>>

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
        val files = FileChannel(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/files")
            .setMethodCallHandler { call, result -> files.handle(call, result) }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "personality/device")
            .setMethodCallHandler { call, result ->
                if (call.method == "probe") {
                    result.success(probe())
                } else {
                    result.notImplemented()
                }
            }
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
        if (requestCode == 41) {
            permissionResult?.success(
                grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)
            permissionResult = null
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
