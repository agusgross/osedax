package com.blkpos.osedax.model

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class CharacterSelect(
    @Expose(serialize = true, deserialize = true)
    @PrimaryKey var name: String = "",
    @Expose(serialize = true, deserialize = true)
    @SerializedName("character_option")
    var option: Int = 0
): RealmObject()