package com.blkpos.osedax.ui

import android.content.Context
import android.util.AttributeSet
import android.util.Log
import android.view.MotionEvent
import androidx.annotation.Nullable
import androidx.core.widget.NestedScrollView
import kotlin.math.abs


class LockableNestedScrollView : NestedScrollView {
    // by default is scrollable
    private var scrollable = true

    private var y1: Float = 0f
    private var y2: Float = 0f
    private var dy: Float = 0f

    constructor(context: Context) : super(context) {}
    constructor(context: Context, @Nullable attrs: AttributeSet?) : super(context, attrs) {}
    constructor(
        context: Context,
        @Nullable attrs: AttributeSet?,
        defStyleAttr: Int
    ) : super(context, attrs, defStyleAttr) {
    }

    override fun onTouchEvent(ev: MotionEvent): Boolean {


        when(ev.action){


            MotionEvent.ACTION_MOVE -> {
                y2 = ev.y
                dy =  y2-y1

            }

        }

        if(dy > 0 ) scrollable = true // allow only scroll down

        return (scrollable) && super.onTouchEvent(ev)
    }

    override fun onInterceptTouchEvent(ev: MotionEvent): Boolean {

        when(ev.action) {

            MotionEvent.ACTION_DOWN -> y1 = ev.y
            MotionEvent.ACTION_MOVE -> {
                y2 = ev.y
                dy =  y2-y1

            }

        }

        if(dy > 0 ) scrollable = true // allow only scroll down

        return (scrollable)  && super.onInterceptTouchEvent(ev)
    }

    fun setScrollingEnabled(enabled: Boolean) {
        scrollable = enabled
    }
}