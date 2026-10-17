package com.dhurta.personality

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

/**
 * Home-screen widget: today's water and the next task. The app writes
 * ready-made, translated text into private preferences; nothing here
 * reads the encrypted database. With app lock on, the task is hidden.
 */
class TodayWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) manager.updateAppWidget(id, views(context))
    }

    companion object {
        const val PREFS = "personality_widget"
        const val ACTION_ADD_WATER = "com.dhurta.personality.ADD_WATER"

        fun save(context: Context, data: Map<*, *>) {
            val e = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
            for ((k, v) in data) {
                when (v) {
                    is String -> e.putString(k as String, v)
                    is Int -> e.putInt(k as String, v)
                    is Long -> e.putInt(k as String, v.toInt())
                    null -> e.remove(k as String)
                }
            }
            e.apply()
            refresh(context)
        }

        fun refresh(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, TodayWidget::class.java))
            for (id in ids) manager.updateAppWidget(id, views(context))
        }

        private fun views(context: Context): RemoteViews {
            val p = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val v = RemoteViews(context.packageName, R.layout.widget_today)
            v.setTextViewText(R.id.widget_water_label, p.getString("waterLabel", "Water"))
            v.setTextViewText(R.id.widget_water_value, p.getString("waterText", "—"))
            v.setProgressBar(R.id.widget_water_bar, 100, p.getInt("waterPercent", 0).coerceIn(0, 100), false)
            v.setTextViewText(R.id.widget_next_label, p.getString("nextLabel", "Next"))
            v.setTextViewText(R.id.widget_next_value, p.getString("nextText", ""))
            v.setTextViewText(R.id.widget_add_water, p.getString("addLabel", "+ Glass"))
            v.setViewVisibility(R.id.widget_next_label,
                if (p.getString("nextText", "").isNullOrEmpty()) View.GONE else View.VISIBLE)

            val open = Intent(context, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            v.setOnClickPendingIntent(R.id.widget_root, PendingIntent.getActivity(
                context, 0, open, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT))
            val add = Intent(context, MainActivity::class.java).setAction(ACTION_ADD_WATER)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            v.setOnClickPendingIntent(R.id.widget_add_water, PendingIntent.getActivity(
                context, 1, add, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT))
            return v
        }
    }
}
