package com.blkpos.osedax.model

import com.blkpos.osedax.di.Exclude
import com.google.gson.annotations.Expose
import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class Chapter(
    @Expose(serialize = true, deserialize = true)
    @PrimaryKey var id: Int = 0,
    @Expose(serialize = false, deserialize = true)
    var title: String = "",
    @Expose(serialize = false, deserialize = true)
    var episodes: RealmList<Episode> = RealmList(),
    @Expose(serialize = false, deserialize = true)
    var purchased: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var numberOfCharacters: Int = 0,
    @Expose(serialize = false, deserialize = true)
    var characterOneOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterOneOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterTwoOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterTwoOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterThreeOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterThreeOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterFourOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterFourOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterFiveOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterFiveOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterSixOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterSixOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterSevenOptionA:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterSevenOptionB:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterOneName:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterTwoName:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterThreeName:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterFourName:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterFiveName:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterSixName:String = "",
    @Expose(serialize = false, deserialize = true)
    var characterSevenName:String = "",
    @Expose(serialize = false, deserialize = true)
    var sku: String = ""
): RealmObject()

