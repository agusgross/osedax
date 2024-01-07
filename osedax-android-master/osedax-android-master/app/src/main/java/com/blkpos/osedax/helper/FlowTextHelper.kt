package com.blkpos.osedax.helper

import android.os.Build
import android.text.SpannableString
import android.text.Spanned
import android.util.FloatMath
import android.view.Display
import android.view.View
import android.widget.RelativeLayout
import android.widget.TextView


internal object FlowTextHelper {
    private var mNewClassAvailable = false
    fun tryFlowText(
        text: String?,
        thumbnailView: View,
        messageView: TextView,
        display: Display
    ) {
        // There is nothing I can do for older versions, so just return
        if (!mNewClassAvailable) return

        // Get height and width of the image and height of the text line
        thumbnailView.measure(display.width, display.height)
        val height: Int = thumbnailView.getMeasuredHeight()
        val width: Int = thumbnailView.getMeasuredWidth()
        val textLineHeight = messageView.paint.textSize

        // Set the span according to the number of lines and width of the image

        val lines = Math.ceil((height / textLineHeight).toDouble()).toInt()-2
        //For an html text you can use this line: SpannableStringBuilder ss = (SpannableStringBuilder)Html.fromHtml(text);
        val ss = SpannableString(text)
        ss.setSpan(
            MyLeadingMarginSpan2(lines, width),
            0,
            ss.length,
            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        messageView.text = ss

        // Align the text with the image by removing the rule that the text is to the right of the image
        val params =
            messageView.layoutParams as RelativeLayout.LayoutParams
        val rules = params.rules
        rules[RelativeLayout.RIGHT_OF] = 0
    }

    init {
        if (Build.VERSION.SDK.toInt() >= 8) { // Froyo 2.2, API level 8
            mNewClassAvailable = true
        }
    }
}