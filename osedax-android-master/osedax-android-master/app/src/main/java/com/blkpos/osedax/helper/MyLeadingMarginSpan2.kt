package com.blkpos.osedax.helper

import android.graphics.Canvas
import android.graphics.Paint
import android.os.Build
import android.text.Layout

import android.text.style.LeadingMarginSpan.LeadingMarginSpan2


class MyLeadingMarginSpan2(private val lines: Int, private val margin: Int) : LeadingMarginSpan2 {
    private var wasDrawCalled = false
    private var drawLineCount = 0
    override fun getLeadingMargin(first: Boolean): Int {
        var isFirstMargin = first
        // a different algorithm for api 21+
        if (Build.VERSION.SDK_INT >= 21) {
            drawLineCount = if (wasDrawCalled) drawLineCount + 1 else 0
            wasDrawCalled = false
            isFirstMargin = drawLineCount <= lines
        }
        return if (isFirstMargin) margin else 0
    }

    override fun drawLeadingMargin(
        c: Canvas?,
        p: Paint?,
        x: Int,
        dir: Int,
        top: Int,
        baseline: Int,
        bottom: Int,
        text: CharSequence?,
        start: Int,
        end: Int,
        first: Boolean,
        layout: Layout?
    ) {
        wasDrawCalled = true
    }

    override fun getLeadingMarginLineCount(): Int {
        return lines
    }

}