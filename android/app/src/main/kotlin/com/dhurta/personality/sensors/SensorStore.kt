package com.dhurta.personality.sensors

import android.content.Context
import org.json.JSONArray

/**
 * Raw on-device sensor events waiting for the app to import them.
 * App-private storage only; nothing leaves the device. Each list is capped
 * so it can't grow without bound if the app isn't opened for a while.
 */
object SensorStore {
    private const val PREFS = "personality_sensors"
    const val STEPS = "steps"        // [timeMs, cumulativeCount]
    const val ACTIVITY = "activity"  // [timeMs, activityType, transition]
    const val SLEEP = "sleep"        // [startMs, endMs, status]
    private const val CAP = 3000

    private fun prefs(c: Context) = c.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    @Synchronized
    fun append(c: Context, key: String, row: List<Long>) {
        val arr = JSONArray(prefs(c).getString(key, "[]"))
        arr.put(JSONArray(row))
        val trimmed = if (arr.length() > CAP) {
            JSONArray().also { out ->
                for (i in arr.length() - CAP until arr.length()) out.put(arr.get(i))
            }
        } else arr
        prefs(c).edit().putString(key, trimmed.toString()).apply()
    }

    @Synchronized
    fun read(c: Context, key: String): List<List<Long>> {
        val arr = JSONArray(prefs(c).getString(key, "[]"))
        return (0 until arr.length()).map { i ->
            val r = arr.getJSONArray(i)
            (0 until r.length()).map { r.getLong(it) }
        }
    }

    /** Drops rows whose first value (time) is before [beforeMs]. */
    @Synchronized
    fun prune(c: Context, key: String, beforeMs: Long) {
        val kept = JSONArray()
        for (row in read(c, key)) if (row[0] >= beforeMs) kept.put(JSONArray(row))
        prefs(c).edit().putString(key, kept.toString()).apply()
    }

    @Synchronized
    fun clearAll(c: Context) = prefs(c).edit().clear().apply()

    fun isEnabled(c: Context, feature: String) = prefs(c).getBoolean("on.$feature", false)

    fun setEnabled(c: Context, feature: String, on: Boolean) =
        prefs(c).edit().putBoolean("on.$feature", on).apply()
}
