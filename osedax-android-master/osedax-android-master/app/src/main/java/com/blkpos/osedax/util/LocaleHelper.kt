package com.blkpos.osedax.util

import android.util.Log
import java.util.*

object LocaleHelper {

    fun getLocale(): String{

//        val locale = Locale.getDefault().toLanguageTag()
//
//        if(locale.length < 2)
//            return "en"
//
//        if(locale.subSequence(0, 2) == "es" && ( locale.length < 5 || locale.subSequence(3, 5) != "AR" ))
//            return "es"
//
//        if ( locale != "en" && locale != "es-AR")
//            return "en"

        val locale = Locale.getDefault().language

        if ( locale != "en" && locale != "es")
            return "en"

        return locale

    }
}