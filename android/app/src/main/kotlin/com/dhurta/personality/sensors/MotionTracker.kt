package com.dhurta.personality.sensors

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.location.ActivityRecognition
import com.google.android.gms.location.ActivityTransition
import com.google.android.gms.location.ActivityTransitionRequest
import com.google.android.gms.location.ActivityTransitionResult
import com.google.android.gms.location.DetectedActivity
import com.google.android.gms.location.SleepSegmentEvent
import com.google.android.gms.location.SleepSegmentRequest

/**
 * Walking / running / cycling transitions and sleep segments from Google
 * Play services' on-device recognition. No account, no network: results
 * arrive as broadcasts and are queued in [SensorStore].
 */
object MotionTracker {
    private const val ACTION = "com.dhurta.personality.MOTION"

    fun playServicesAvailable(c: Context) =
        GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(c) ==
            ConnectionResult.SUCCESS

    private fun intent(c: Context): PendingIntent {
        val i = Intent(c, MotionReceiver::class.java).setAction(ACTION)
        // Mutable: Play services adds the results to the intent.
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0)
        return PendingIntent.getBroadcast(c, 7, i, flags)
    }

    @SuppressLint("MissingPermission") // checked by the caller
    fun start(c: Context, activity: Boolean, sleep: Boolean) {
        val client = ActivityRecognition.getClient(c)
        if (activity) {
            val types = listOf(
                DetectedActivity.WALKING,
                DetectedActivity.RUNNING,
                DetectedActivity.ON_BICYCLE,
            )
            val transitions = types.flatMap { t ->
                listOf(
                    ActivityTransition.Builder().setActivityType(t)
                        .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_ENTER).build(),
                    ActivityTransition.Builder().setActivityType(t)
                        .setActivityTransition(ActivityTransition.ACTIVITY_TRANSITION_EXIT).build(),
                )
            }
            client.requestActivityTransitionUpdates(ActivityTransitionRequest(transitions), intent(c))
        }
        if (sleep) {
            client.requestSleepSegmentUpdates(
                intent(c), SleepSegmentRequest.getDefaultSleepSegmentRequest())
        }
    }

    @SuppressLint("MissingPermission")
    fun stop(c: Context) {
        val client = ActivityRecognition.getClient(c)
        runCatching { client.removeActivityTransitionUpdates(intent(c)) }
        runCatching { client.removeSleepSegmentUpdates(intent(c)) }
    }
}

class MotionReceiver : BroadcastReceiver() {
    override fun onReceive(c: Context, intent: Intent) {
        if (ActivityTransitionResult.hasResult(intent)) {
            ActivityTransitionResult.extractResult(intent)?.transitionEvents?.forEach { e ->
                // elapsedRealtimeNanos → wall-clock time.
                val ms = System.currentTimeMillis() -
                    (android.os.SystemClock.elapsedRealtimeNanos() - e.elapsedRealTimeNanos) / 1_000_000
                SensorStore.append(c, SensorStore.ACTIVITY,
                    listOf(ms, e.activityType.toLong(), e.transitionType.toLong()))
            }
        }
        if (SleepSegmentEvent.hasEvents(intent)) {
            SleepSegmentEvent.extractEvents(intent).forEach { s ->
                SensorStore.append(c, SensorStore.SLEEP,
                    listOf(s.startTimeMillis, s.endTimeMillis, s.status.toLong()))
            }
        }
    }
}

/** Re-registers tracking after a reboot (registrations don't survive it). */
class SensorBootReceiver : BroadcastReceiver() {
    override fun onReceive(c: Context, intent: Intent) {
        val activity = SensorStore.isEnabled(c, "activity")
        val sleep = SensorStore.isEnabled(c, "sleep")
        if ((activity || sleep) && MotionTracker.playServicesAvailable(c)) {
            runCatching { MotionTracker.start(c, activity, sleep) }
        }
        if (SensorStore.isEnabled(c, "steps")) StepSampler.schedule(c)
    }
}
