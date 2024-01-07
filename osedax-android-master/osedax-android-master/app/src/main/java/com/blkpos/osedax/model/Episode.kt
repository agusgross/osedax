package com.blkpos.osedax.model

import com.google.gson.annotations.Expose
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class Episode(
    @Expose(serialize = true, deserialize = true)
    @PrimaryKey var id: Int = 0,
    @Expose(serialize = false, deserialize = true)
    var title: String = "",
    @Expose(serialize = false, deserialize = true)
    var text: String = "",
    @Expose(serialize = false, deserialize = true)
    var text2: String = "",
    @Expose(serialize = false, deserialize = true)
    var textByCharacters: String = "",
    @Expose(serialize = false, deserialize = true)
    var text2ByCharacters: String = "",
    @Expose(serialize = false, deserialize = true)
    var image: String = "",
    @Expose(serialize = false, deserialize = true)
    var isFirstCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var isSecondCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var isThirdCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var isFourthCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var isFifthCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var isSixthCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var isSeventhCharacterPresent: Boolean = false,
    @Expose(serialize = false, deserialize = true)
    var episodeNumber: Int = 0
): RealmObject() {

//    fun getEpisodeImage(firstCharacter: Int, secondCharacter: Int, thirdCharacter: Int){
//
//
//        var image = "${id}_"
//
//
//
//    }

}