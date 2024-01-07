package com.blkpos.osedax.extension

import android.content.Context
import android.text.Spannable
import android.text.SpannableString
import android.text.style.BackgroundColorSpan
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.blkpos.osedax.R


fun TextView.selectText(context: Context, from: Int, to: Int) {

    val wordToSpan: Spannable = SpannableString(text)
    wordToSpan.setSpan(
        BackgroundColorSpan(ContextCompat.getColor(context, R.color.colorAccent)),
//        BackgroundColorWithoutLineHeightSpan(ContextCompat.getColor(context, R.color.colorAccent), 24.px),
        from,
        to,
        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
    )
    setText(wordToSpan, TextView.BufferType.SPANNABLE)


}

