package com.blkpos.osedax.model

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required

open class TextClipping(
    @PrimaryKey
    @SerializedName("foreign_id")
    @Expose(serialize = true, deserialize = false)
    var id: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var text: String? = "",
    @Expose(serialize = true, deserialize = true)
    var indexStart: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var indexEnd: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var chapter: Chapter? = null,
    @Expose(serialize = true, deserialize = true)
    var episode: Episode? = null,
    @Expose(serialize = true, deserialize = true)
    var position: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var paragraph: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var language: String? = "",
    @Expose(serialize = true, deserialize = true)
    var characterCode: String? = ""

): RealmObject()