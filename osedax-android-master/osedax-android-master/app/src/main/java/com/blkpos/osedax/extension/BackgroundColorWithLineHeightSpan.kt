package com.blkpos.osedax.extension

import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.text.style.ReplacementSpan
import kotlin.math.roundToInt


class BackgroundColorWithoutLineHeightSpan(private val mColor: Int, private val mTextHeight: Int) :
    ReplacementSpan() {
    override fun getSize(
        paint: Paint,
        text: CharSequence,
        start: Int,
        end: Int,
        fm: Paint.FontMetricsInt?
    ): Int {
        return measureText(paint, text, start, end).roundToInt()
    }

    override fun draw(
        canvas: Canvas,
        text: CharSequence,
        start: Int,
        end: Int,
        x: Float,
        top: Int,
        y: Int,
        bottom: Int,
        paint: Paint
    ) {
        val paintColor: Int = paint.color
        val rect = RectF(
            x, top.toFloat(), x + measureText(paint, text, start, end),
            (top + mTextHeight).toFloat()
        )
        paint.color = mColor
        canvas.drawRect(rect, paint)
        paint.color = paintColor
        canvas.drawText(text, start, end, x, y.toFloat(), paint)
    }

    private fun measureText(paint: Paint, text: CharSequence, start: Int, end: Int): Float {
        return paint.measureText(text, start, end)
    }
}

