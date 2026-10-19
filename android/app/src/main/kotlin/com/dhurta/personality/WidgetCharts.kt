package com.dhurta.personality

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.graphics.Shader

/**
 * Small charts for home-screen widgets, drawn to bitmaps (RemoteViews can't
 * host custom views). Sizes are in dp and scaled for the screen.
 */
object WidgetCharts {
    private fun px(context: Context, dp: Float) = dp * context.resources.displayMetrics.density

    /** Parses "0.4,1,0.25" (blank or bad entries count as 0). */
    fun floats(raw: String?): List<Float> =
        raw?.split(',')?.filter { it.isNotBlank() }?.map { it.toFloatOrNull() ?: 0f } ?: emptyList()

    fun labels(raw: String?): List<String> = raw?.split('|') ?: emptyList()

    /**
     * Rounded bars for [values] in 0..1, with day [labels] underneath.
     * The last bar (today) is solid; earlier ones are lighter.
     */
    fun bars(
        context: Context, values: List<Float>, labels: List<String>,
        color: Int, track: Int, labelColor: Int, widthDp: Float, heightDp: Float,
    ): Bitmap {
        val w = px(context, widthDp).toInt().coerceAtLeast(1)
        val h = px(context, heightDp).toInt().coerceAtLeast(1)
        val bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
        if (values.isEmpty()) return bmp
        val c = Canvas(bmp)
        val text = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = labelColor
            textSize = px(context, 10f)
            textAlign = Paint.Align.CENTER
        }
        val labelH = if (labels.isEmpty()) 0f else text.textSize + px(context, 4f)
        val n = values.size
        val slot = w.toFloat() / n
        val barW = slot * 0.56f
        val top = px(context, 2f)
        val bottom = h - labelH
        val r = barW / 2
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        for (i in 0 until n) {
            val cx = slot * i + slot / 2
            paint.color = track
            c.drawRoundRect(RectF(cx - barW / 2, top, cx + barW / 2, bottom), r, r, paint)
            val v = values[i].coerceIn(0f, 1f)
            if (v > 0f) {
                val barTop = bottom - (bottom - top) * v
                paint.color = if (i == n - 1) color else withAlpha(color, 0.6f)
                c.drawRoundRect(
                    RectF(cx - barW / 2, minOf(barTop, bottom - barW), cx + barW / 2, bottom), r, r, paint)
            }
            labels.getOrNull(i)?.let { c.drawText(it, cx, h - px(context, 2f), text) }
        }
        return bmp
    }

    /** A progress ring for [fraction] in 0..1. */
    fun ring(context: Context, fraction: Float, color: Int, track: Int, sizeDp: Float, strokeDp: Float): Bitmap {
        val s = px(context, sizeDp).toInt().coerceAtLeast(1)
        val stroke = px(context, strokeDp)
        val bmp = Bitmap.createBitmap(s, s, Bitmap.Config.ARGB_8888)
        val c = Canvas(bmp)
        val p = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = stroke
            strokeCap = Paint.Cap.ROUND
        }
        val box = RectF(stroke / 2, stroke / 2, s - stroke / 2, s - stroke / 2)
        p.color = track
        c.drawArc(box, 0f, 360f, false, p)
        val f = fraction.coerceIn(0f, 1f)
        if (f > 0f) {
            p.color = color
            c.drawArc(box, -90f, 360f * f, false, p)
        }
        return bmp
    }

    /** A smooth line with a soft fill for a trend such as weight. */
    fun line(context: Context, values: List<Float>, color: Int, widthDp: Float, heightDp: Float): Bitmap {
        val w = px(context, widthDp).toInt().coerceAtLeast(1)
        val h = px(context, heightDp).toInt().coerceAtLeast(1)
        val bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
        if (values.size < 2) return bmp
        val c = Canvas(bmp)
        val pad = px(context, 6f)
        val min = values.min()
        val max = values.max()
        val span = (max - min).takeIf { it > 0f } ?: 1f
        val pts = values.mapIndexed { i, v ->
            val x = pad + (w - 2 * pad) * i / (values.size - 1)
            val y = pad + (h - 2 * pad) * (1 - (v - min) / span)
            x to y
        }
        val path = Path().apply {
            moveTo(pts[0].first, pts[0].second)
            for (i in 1 until pts.size) {
                val (x0, y0) = pts[i - 1]
                val (x1, y1) = pts[i]
                val mx = (x0 + x1) / 2
                cubicTo(mx, y0, mx, y1, x1, y1)
            }
        }
        val fill = Path(path).apply {
            lineTo(pts.last().first, h.toFloat())
            lineTo(pts.first().first, h.toFloat())
            close()
        }
        c.drawPath(fill, Paint(Paint.ANTI_ALIAS_FLAG).apply {
            shader = LinearGradient(0f, 0f, 0f, h.toFloat(),
                withAlpha(color, 0.35f), withAlpha(color, 0f), Shader.TileMode.CLAMP)
        })
        c.drawPath(path, Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = color
            style = Paint.Style.STROKE
            strokeWidth = px(context, 2.5f)
            strokeCap = Paint.Cap.ROUND
            strokeJoin = Paint.Join.ROUND
        })
        val (lx, ly) = pts.last()
        c.drawCircle(lx, ly, px(context, 4.5f), Paint(Paint.ANTI_ALIAS_FLAG).apply { this.color = Color.WHITE })
        c.drawCircle(lx, ly, px(context, 3f), Paint(Paint.ANTI_ALIAS_FLAG).apply { this.color = color })
        return bmp
    }

    private fun withAlpha(color: Int, a: Float) =
        Color.argb((Color.alpha(color) * a).toInt(), Color.red(color), Color.green(color), Color.blue(color))
}
