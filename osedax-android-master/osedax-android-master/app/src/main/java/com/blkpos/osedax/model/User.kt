package com.blkpos.osedax.model

import android.os.Parcel
import android.os.Parcelable
import com.google.gson.annotations.Expose
import kotlinx.android.parcel.Parcelize

@Parcelize
data class User(
    @Expose(serialize = true, deserialize = true)
    var id: Int? = null,
    @Expose(serialize = true, deserialize = true)
    var email: String? = null,
    @Expose(serialize = true, deserialize = true)
    var username: String? = null,
    @Expose(serialize = true, deserialize = true)
    var plainPassword: String? = null,
    @Expose(serialize = true, deserialize = true)
    var firstName: String? = null,
    @Expose(serialize = true, deserialize = true)
    var lastName: String? = null,
    @Expose(serialize = true, deserialize = true)
    var emailNotifications: Boolean? = false
): Parcelable {

    companion object {
        var currentUser: User? = null
    }

    constructor(username: String?) : this() {

        this.username = username
    }

    override fun toString(): String {
        return username ?: ""
    }



}