package com.blkpos.osedax.model

import com.google.gson.annotations.Expose

data class InitResponse(
    @Expose(serialize = false, deserialize = true)
    val textClippings: ArrayList<TextClipping>,
    @Expose(serialize = false, deserialize = true)
    val bookmarks: ArrayList<Bookmark>,
    @Expose(serialize = false, deserialize = true)
    val characterSelects: ArrayList<CharacterSelect>)