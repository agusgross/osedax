package com.blkpos.osedax.extension

import android.annotation.SuppressLint
import android.graphics.Rect
import android.view.MotionEvent
import android.view.View

@SuppressLint("ClickableViewAccessibility")
fun View.setChildViewOnScreenListener(view: View, action: () -> Unit) {

    this.setOnTouchListener { _, motionEvent ->
        if (motionEvent.action == MotionEvent.ACTION_MOVE) {

            if (isSubViewVisible(view)) {
                action()
            }
        }

        false
    }
}

fun View.isSubViewVisible(view: View): Boolean {

    val visibleScreen = Rect()
    this.getDrawingRect(visibleScreen)
    return view.getLocalVisibleRect(visibleScreen)

}