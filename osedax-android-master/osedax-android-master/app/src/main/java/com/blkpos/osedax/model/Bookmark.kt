package com.blkpos.osedax.model

import com.google.gson.annotations.Expose
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class Bookmark(
    @Expose(serialize = false, deserialize = false)
    @PrimaryKey var id: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var chapter: Chapter? = null,
    @Expose(serialize = true, deserialize = true)
    var episode: Episode? = null,
    @Expose(serialize = true, deserialize = true)
    var position: Int = 0,
    @Expose(serialize = true, deserialize = true)
    var characterCode: String? = ""

): RealmObject() {

    constructor(chapter: Chapter, episode: Episode): this(0, chapter, episode, 0)
    constructor(chapter: Chapter, episode: Episode, position: Int): this(0, chapter, episode, position)
    constructor(chapter: Chapter, episode: Episode, position: Int, characterCode: String?): this(0, chapter, episode, position, characterCode)

}
