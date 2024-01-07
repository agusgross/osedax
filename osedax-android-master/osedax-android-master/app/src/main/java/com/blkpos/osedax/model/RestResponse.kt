package com.blkpos.osedax.model

import com.google.gson.annotations.Expose
import java.util.*

class RestResponse {
    @Expose(serialize = true, deserialize = true)
    var ok = false
    @Expose(serialize = true, deserialize = true)
    var errors: ArrayList<ErrorResponse>? = null

    fun getErrorDescription(): String{

        val errors = errors?.map {
            it.message
        }?.fold("", { acc, s ->

            acc + s + "\n"

        })

        return errors ?: ""

    }
}