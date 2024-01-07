package com.blkpos.osedax.util

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.text.InputType
import android.widget.EditText
import androidx.core.content.res.ResourcesCompat
import com.blkpos.osedax.R

object DialogHelper {

    fun showDialog(
        context: Context,
        title: Int,
        message: String,
        okButton: Int,
        listener: () -> Unit = {},
        cancelButton: Int = 0
    ){

        val builder = AlertDialog.Builder(context, R.style.AppTheme_Dialog)

        builder.setTitle(title)
            .setMessage(message)
            .setPositiveButton(okButton, DialogInterface.OnClickListener { dialog, which ->
                listener()
            })

        if ( cancelButton != 0 ) {
            builder.setNegativeButton(cancelButton, null)
        }

        builder.show()


    }



}