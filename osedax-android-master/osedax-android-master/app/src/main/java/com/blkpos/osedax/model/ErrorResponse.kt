package com.blkpos.osedax.model

import com.google.gson.annotations.Expose

class ErrorResponse {
    @Expose(serialize = true, deserialize = true)
    var message: String? = null
    @Expose(serialize = true, deserialize = true)
    var propertyPath: String? = null

}
