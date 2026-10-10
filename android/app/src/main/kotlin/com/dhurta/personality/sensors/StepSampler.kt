package com.dhurta.personality.sensors

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/** Reads the phone's hardware step counter (steps since the last reboot). */
object StepSampler {
    private const val WORK = "personality.steps"

    fun hasSensor(c: Context): Boolean =
        (c.getSystemService(Context.SENSOR_SERVICE) as SensorManager)
            .getDefaultSensor(Sensor.TYPE_STEP_COUNTER) != null

    /** One reading, or null if the sensor didn't answer in time. */
    fun read(c: Context, timeoutMs: Long = 4000): Long? {
        val sm = c.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val sensor = sm.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) ?: return null
        val latch = CountDownLatch(1)
        var value: Long? = null
        val listener = object : SensorEventListener {
            override fun onSensorChanged(e: SensorEvent) {
                value = e.values[0].toLong()
                latch.countDown()
            }

            override fun onAccuracyChanged(s: Sensor?, a: Int) {}
        }
        sm.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        latch.await(timeoutMs, TimeUnit.MILLISECONDS)
        sm.unregisterListener(listener)
        return value
    }

    /** Records one sample now. */
    fun sample(c: Context) {
        val v = read(c) ?: return
        SensorStore.append(c, SensorStore.STEPS, listOf(System.currentTimeMillis(), v))
    }

    fun schedule(c: Context) {
        WorkManager.getInstance(c).enqueueUniquePeriodicWork(
            WORK,
            ExistingPeriodicWorkPolicy.KEEP,
            PeriodicWorkRequestBuilder<StepSampleWorker>(15, TimeUnit.MINUTES).build(),
        )
    }

    fun cancel(c: Context) = WorkManager.getInstance(c).cancelUniqueWork(WORK)
}

class StepSampleWorker(ctx: Context, params: WorkerParameters) : Worker(ctx, params) {
    override fun doWork(): Result {
        if (SensorStore.isEnabled(applicationContext, "steps")) {
            StepSampler.sample(applicationContext)
        }
        return Result.success()
    }
}
