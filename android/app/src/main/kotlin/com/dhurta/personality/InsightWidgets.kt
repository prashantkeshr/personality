package com.dhurta.personality

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews

/**
 * Growth, exercise and weight widgets. Like [TodayWidget] they only show
 * ready-made, translated text and numbers the app saved (keys prefixed
 * g_, e_, w_); with app lock on the app saves no personal values.
 */
object InsightWidgets {
    const val ACTION_OPEN = "com.dhurta.personality.OPEN_ROUTE"
    const val EXTRA_ROUTE = "route"

    fun refreshAll(context: Context) {
        val m = AppWidgetManager.getInstance(context)
        fun each(cls: Class<*>, views: (Context) -> RemoteViews) {
            for (id in m.getAppWidgetIds(ComponentName(context, cls))) m.updateAppWidget(id, views(context))
        }
        each(GrowthWidget::class.java, ::growth)
        each(ExerciseWidget::class.java, ::exercise)
        each(WeightWidget::class.java, ::weight)
    }

    private fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(TodayWidget.PREFS, Context.MODE_PRIVATE)

    /** Opens the app at [route] (handled once by the app on start/resume). */
    private fun open(context: Context, route: String, code: Int): PendingIntent {
        val i = Intent(context, MainActivity::class.java)
            .setAction(ACTION_OPEN)
            .putExtra(EXTRA_ROUTE, route)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        return PendingIntent.getActivity(context, code, i,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
    }

    private fun color(context: Context, id: Int) = context.getColor(id)

    fun growth(context: Context): RemoteViews {
        val p = prefs(context)
        val v = RemoteViews(context.packageName, R.layout.widget_growth)
        val locked = p.getBoolean("locked", false)
        v.setTextViewText(R.id.growth_title, p.getString("g_title", "My growth"))
        v.setTextViewText(R.id.growth_level, if (locked) p.getString("lockedText", "") else p.getString("g_level", "—"))
        v.setTextViewText(R.id.growth_streak, if (locked) "" else p.getString("g_streak", ""))
        v.setTextViewText(R.id.growth_xp, if (locked) "" else p.getString("g_xp", ""))
        v.setProgressBar(R.id.growth_bar, 100, if (locked) 0 else p.getInt("g_progress", 0).coerceIn(0, 100), false)
        v.setTextViewText(R.id.growth_chart_label, if (locked) "" else p.getString("g_chartLabel", ""))
        val values = WidgetCharts.floats(p.getString("g_week", null))
        if (locked || values.isEmpty()) {
            v.setViewVisibility(R.id.growth_chart, View.GONE)
        } else {
            v.setViewVisibility(R.id.growth_chart, View.VISIBLE)
            v.setImageViewBitmap(R.id.growth_chart, WidgetCharts.bars(
                context, values, WidgetCharts.labels(p.getString("days", null)),
                color(context, R.color.widget_growth_bar), color(context, R.color.widget_growth_track),
                color(context, R.color.widget_on_dark_secondary), 260f, 64f))
        }
        v.setOnClickPendingIntent(R.id.growth_root, open(context, "/growth", 10))
        return v
    }

    fun exercise(context: Context): RemoteViews {
        val p = prefs(context)
        val v = RemoteViews(context.packageName, R.layout.widget_exercise)
        val locked = p.getBoolean("locked", false)
        v.setTextViewText(R.id.exercise_title, p.getString("e_title", "Exercise"))
        v.setTextViewText(R.id.exercise_value, if (locked) p.getString("lockedText", "") else p.getString("e_value", "—"))
        v.setTextViewText(R.id.exercise_week, if (locked) "" else p.getString("e_week_text", ""))
        v.setTextViewText(R.id.exercise_ring_text, if (locked) "" else p.getString("e_percent_text", ""))
        v.setTextViewText(R.id.exercise_start, p.getString("e_start", "Start"))
        val accent = color(context, R.color.widget_exercise_accent)
        val track = color(context, R.color.widget_exercise_track)
        v.setImageViewBitmap(R.id.exercise_ring, WidgetCharts.ring(
            context, if (locked) 0f else p.getInt("e_percent", 0) / 100f, accent, track, 64f, 7f))
        val values = WidgetCharts.floats(p.getString("e_bars", null))
        if (locked || values.isEmpty()) {
            v.setViewVisibility(R.id.exercise_chart, View.GONE)
        } else {
            v.setViewVisibility(R.id.exercise_chart, View.VISIBLE)
            v.setImageViewBitmap(R.id.exercise_chart, WidgetCharts.bars(
                context, values, WidgetCharts.labels(p.getString("days", null)),
                accent, track, color(context, R.color.widget_on_dark_secondary), 260f, 58f))
        }
        v.setOnClickPendingIntent(R.id.exercise_root, open(context, "/health/exercise", 11))
        v.setOnClickPendingIntent(R.id.exercise_start, open(context, "/health/exercise/programs", 12))
        return v
    }

    fun weight(context: Context): RemoteViews {
        val p = prefs(context)
        val v = RemoteViews(context.packageName, R.layout.widget_weight)
        val locked = p.getBoolean("locked", false)
        val values = WidgetCharts.floats(p.getString("w_values", null))
        v.setTextViewText(R.id.weight_title, p.getString("w_title", "Weight"))
        v.setTextViewText(R.id.weight_value, when {
            locked -> p.getString("lockedText", "")
            else -> p.getString("w_value", "—")
        })
        v.setTextViewText(R.id.weight_change, if (locked) "" else p.getString("w_change", ""))
        if (locked || values.size < 2) {
            v.setViewVisibility(R.id.weight_chart, View.GONE)
        } else {
            v.setViewVisibility(R.id.weight_chart, View.VISIBLE)
            v.setImageViewBitmap(R.id.weight_chart, WidgetCharts.line(
                context, values, color(context, R.color.widget_weight_accent), 260f, 70f))
        }
        v.setOnClickPendingIntent(R.id.weight_root, open(context, "/health/weight", 13))
        return v
    }
}

class GrowthWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) manager.updateAppWidget(id, InsightWidgets.growth(context))
    }
}

class ExerciseWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) manager.updateAppWidget(id, InsightWidgets.exercise(context))
    }
}

class WeightWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) manager.updateAppWidget(id, InsightWidgets.weight(context))
    }
}
