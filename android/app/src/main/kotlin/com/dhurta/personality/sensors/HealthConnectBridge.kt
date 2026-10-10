package com.dhurta.personality.sensors

import android.content.Context
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.DistanceRecord
import androidx.health.connect.client.records.ExerciseSessionRecord
import androidx.health.connect.client.records.HeightRecord
import androidx.health.connect.client.records.HydrationRecord
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.request.AggregateGroupByPeriodRequest
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import java.time.Instant
import java.time.LocalDateTime
import java.time.Period
import java.time.ZoneId

/**
 * Read-only access to Health Connect — Android's on-device health store —
 * when it is already present on the phone. Never asks the user to install
 * anything; nothing is written back.
 */
object HealthConnectBridge {
    val permissions = setOf(
        HealthPermission.getReadPermission(StepsRecord::class),
        HealthPermission.getReadPermission(DistanceRecord::class),
        HealthPermission.getReadPermission(ExerciseSessionRecord::class),
        HealthPermission.getReadPermission(SleepSessionRecord::class),
        HealthPermission.getReadPermission(WeightRecord::class),
        HealthPermission.getReadPermission(HeightRecord::class),
        HealthPermission.getReadPermission(HydrationRecord::class),
    )

    /** "available", or "unavailable" when Health Connect isn't on the phone. */
    fun status(c: Context): String =
        if (HealthConnectClient.getSdkStatus(c) == HealthConnectClient.SDK_AVAILABLE)
            "available" else "unavailable"

    suspend fun granted(c: Context): Set<String> =
        HealthConnectClient.getOrCreate(c).permissionController.getGrantedPermissions()

    private fun kind(type: Int): String = when (type) {
        ExerciseSessionRecord.EXERCISE_TYPE_RUNNING,
        ExerciseSessionRecord.EXERCISE_TYPE_RUNNING_TREADMILL -> "running"
        ExerciseSessionRecord.EXERCISE_TYPE_WALKING -> "walking"
        ExerciseSessionRecord.EXERCISE_TYPE_BIKING,
        ExerciseSessionRecord.EXERCISE_TYPE_BIKING_STATIONARY -> "cycling"
        ExerciseSessionRecord.EXERCISE_TYPE_SWIMMING_OPEN_WATER,
        ExerciseSessionRecord.EXERCISE_TYPE_SWIMMING_POOL -> "swimming"
        else -> "other"
    }

    /** Everything readable since [sinceMs], as plain lists for the channel. */
    suspend fun read(c: Context, sinceMs: Long): Map<String, Any> {
        val client = HealthConnectClient.getOrCreate(c)
        val granted = granted(c)
        val zone = ZoneId.systemDefault()
        val start = Instant.ofEpochMilli(sinceMs)
        val now = Instant.now()
        val range = TimeRangeFilter.between(start, now)
        val out = mutableMapOf<String, Any>()

        fun can(p: kotlin.reflect.KClass<out androidx.health.connect.client.records.Record>) =
            HealthPermission.getReadPermission(p) in granted

        if (can(StepsRecord::class)) {
            val startLocal = LocalDateTime.ofInstant(start, zone).toLocalDate().atStartOfDay()
            val rows = client.aggregateGroupByPeriod(
                AggregateGroupByPeriodRequest(
                    metrics = setOf(StepsRecord.COUNT_TOTAL),
                    timeRangeFilter = TimeRangeFilter.between(startLocal, LocalDateTime.now(zone)),
                    timeRangeSlicer = Period.ofDays(1),
                ),
            )
            out["steps"] = rows.map { r ->
                listOf(r.startTime.atZone(zone).toInstant().toEpochMilli(),
                    r.result[StepsRecord.COUNT_TOTAL] ?: 0L)
            }
        }
        if (can(ExerciseSessionRecord::class)) {
            val sessions = client.readRecords(
                ReadRecordsRequest(ExerciseSessionRecord::class, range)).records
            out["exercise"] = sessions.map { s ->
                val km = if (can(DistanceRecord::class)) {
                    client.aggregate(AggregateRequest(
                        setOf(DistanceRecord.DISTANCE_TOTAL),
                        TimeRangeFilter.between(s.startTime, s.endTime),
                    ))[DistanceRecord.DISTANCE_TOTAL]?.inKilometers
                } else null
                mapOf(
                    "id" to s.metadata.id,
                    "start" to s.startTime.toEpochMilli(),
                    "end" to s.endTime.toEpochMilli(),
                    "kind" to kind(s.exerciseType),
                    "km" to km,
                )
            }
        }
        if (can(SleepSessionRecord::class)) {
            out["sleep"] = client.readRecords(
                ReadRecordsRequest(SleepSessionRecord::class, range)).records.map { s ->
                mapOf("id" to s.metadata.id, "start" to s.startTime.toEpochMilli(),
                    "end" to s.endTime.toEpochMilli())
            }
        }
        if (can(WeightRecord::class)) {
            out["weight"] = client.readRecords(
                ReadRecordsRequest(WeightRecord::class, range)).records.map { r ->
                mapOf("id" to r.metadata.id, "time" to r.time.toEpochMilli(),
                    "value" to r.weight.inKilograms)
            }
        }
        if (can(HeightRecord::class)) {
            out["height"] = client.readRecords(
                ReadRecordsRequest(HeightRecord::class, range)).records.map { r ->
                mapOf("id" to r.metadata.id, "time" to r.time.toEpochMilli(),
                    "value" to r.height.inMeters * 100)
            }
        }
        if (can(HydrationRecord::class)) {
            out["water"] = client.readRecords(
                ReadRecordsRequest(HydrationRecord::class, range)).records.map { r ->
                mapOf("id" to r.metadata.id, "time" to r.endTime.toEpochMilli(),
                    "value" to r.volume.inMilliliters)
            }
        }
        return out
    }
}
