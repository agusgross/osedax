package com.blkpos.osedax.store

import android.util.Log
import com.blkpos.osedax.model.*
import com.blkpos.osedax.util.LocaleHelper
import io.realm.Realm
import io.realm.kotlin.where
import java.util.*
import kotlin.collections.ArrayList

class ChapterStore(private val realm: Realm){

    private var _chapters: ArrayList<Chapter>? = null
    var chapters: ArrayList<Chapter>
        get() {

            if (_chapters == null) {
                _chapters = ArrayList()
                realm.executeTransaction { realm ->
                    _chapters?.addAll(realm.where<Chapter>().findAll())
                }
            }

            return _chapters!!
        }

        set(chaptersToAdd) {

            _chapters = chaptersToAdd

            realm.executeTransaction { realm ->
                realm.where<Chapter>().findAll().deleteAllFromRealm()
                realm.where<Episode>().findAll().deleteAllFromRealm()

                chaptersToAdd?.forEach {

                    realm.copyToRealmOrUpdate(it)


                }

            }


        }

    fun addChapter(chapter: Chapter){
        realm.executeTransaction { realm ->

            val chapterInDb = realm.where<Chapter>().equalTo("id", chapter.id).findFirst()
            chapterInDb?.purchased = true

            for (episode in chapter.episodes) {
                val episodeInDb = realm.where<Episode>().equalTo("id", episode.id).findFirst()

                episodeInDb?.text = episode.text
                episodeInDb?.text2 = episode.text2
                episodeInDb?.image = episode.image


            }

            _chapters = ArrayList()
            _chapters?.addAll(realm.where<Chapter>().findAll())

//            realm.copyToRealmOrUpdate(chapter)

        }
    }

    fun appendNewChapter(chapter: Chapter){

        realm.executeTransaction { realm ->

//            val chapterInDb = realm.where<Chapter>().equalTo("id", chapter.id).findFirst()
//            if (chapterInDb == null) {

                realm.copyToRealmOrUpdate(chapter)

                _chapters = ArrayList()
                _chapters?.addAll(realm.where<Chapter>().findAll())

//            }
        }

    }

    fun saveTextClipping(text: String, indexStart: Int, indexEnd: Int, episode: Episode, chapter: Chapter, paragraph: Int, position: Int, characterCode: String): TextClipping?{

        val id = ((realm.where<TextClipping>().max("id") ?: 0 ).toInt() + 1)
        val textClipping = TextClipping(id,text, indexStart, indexEnd, chapter, episode, position, paragraph, LocaleHelper.getLocale(), characterCode)

        realm.executeTransaction { realm ->

            realm.copyToRealmOrUpdate(textClipping)

        }


        return realm.copyFromRealm(realm.where<TextClipping>().equalTo("id", id).findFirst())
    }

    fun saveTextClipping(textClipping: TextClipping){

        val id = ((realm.where<TextClipping>().max("id") ?: 0 ).toInt() + 1)
        textClipping.id = id

        realm.executeTransaction { realm ->

            realm.copyToRealmOrUpdate(textClipping)

        }



    }

    fun getClippings(episode: Episode? = null): ArrayList<TextClipping>{
        val clippings = ArrayList<TextClipping>()

        if( episode != null )
            clippings.addAll(realm.where<TextClipping>().equalTo("episode.id", episode.id).equalTo("language", LocaleHelper.getLocale()).findAll())
        else
            clippings.addAll(realm.where<TextClipping>().equalTo("language", LocaleHelper.getLocale()).findAll())

        return clippings
    }

    fun getClipping(clippingId: Int): TextClipping?{

        return realm.where<TextClipping>().equalTo("id", clippingId).findFirst()

    }

    fun deleteClipping(id: Int){

        realm.executeTransaction {
            realm.where<TextClipping>().equalTo("id", id).findFirst()?.deleteFromRealm()
        }

    }

    private var _bookmark: Bookmark? = null
    var bookmark: Bookmark?
        get(){
            if(_bookmark == null){
                realm.executeTransaction{ realm ->
                    _bookmark = realm.where<Bookmark>().findFirst()
                }
            }

            return _bookmark
        }
        set(newBookmark){
            realm.executeTransaction {
                realm.where<Bookmark>().findAll().deleteAllFromRealm()
                realm.copyToRealmOrUpdate(newBookmark)
                _bookmark = newBookmark
            }
        }

    fun getEpisodeText(chapterId: Int, episodeId: Int): String {

        return episode(chapterId, episodeId).textByCharacters

    }

    fun getEpisodeText2(chapterId: Int, episodeId: Int): String {


        return episode(chapterId, episodeId).text2ByCharacters

    }

    fun getEpisodeTitle(chapterId: Int, episodeId: Int): String {


        return episode(chapterId, episodeId).title

    }

    fun getChapterTitle(chapterId: Int): String {


        return chapter(chapterId).title

    }

    fun getChapterNumber(chapterId: Int): Int {


        return chapters.indexOf(chapter(chapterId))+1

    }

    fun episode(chapterId: Int, episodeId: Int): Episode{

        return chapters.first { it.id == chapterId }.episodes.first { it.id == episodeId }
    }

    fun chapter(chapterId: Int): Chapter{

        val chapter = chapters.firstOrNull {
            it.id == chapterId
        }

        return chapter!!
    }



    fun nextCharacterSet(currentCharacterSet: Int, chapterId: Int?, episodeId: Int?): Int?{

        val chapter = if(chapterId != null ) chapter(chapterId) else chapter(firstChapterId())

        val n = chapter.numberOfCharacters

        if ( currentCharacterSet == n-1){ // if last characterset

            return null

        } else {

            val episode = if( episodeId != null ) episode(chapter.id, episodeId) else episode(chapter.id, firstEpisodeId()!!)


            var nextCharacterSet = currentCharacterSet + 1
//
            if (nextCharacterSet == 1) {
                if (episode.isSecondCharacterPresent && characterSelection(chapter.characterTwoName) == null)
                    return nextCharacterSet
                else
                    return nextCharacterSet(nextCharacterSet, chapterId, episodeId)

            } else if (nextCharacterSet == 2) {

                if (episode.isThirdCharacterPresent && characterSelection(chapter.characterThreeName) == null)
                    return nextCharacterSet
                else
                    return nextCharacterSet(nextCharacterSet, chapterId, episodeId)

            } else if (nextCharacterSet == 3) {

                if (episode.isFourthCharacterPresent && characterSelection(chapter.characterFourName) == null)
                    return nextCharacterSet
                else
                    return nextCharacterSet(nextCharacterSet, chapterId, episodeId)

            } else if (nextCharacterSet == 4) {

                if (episode.isFifthCharacterPresent && characterSelection(chapter.characterFiveName) == null)
                    return nextCharacterSet
                else
                    return nextCharacterSet(nextCharacterSet, chapterId, episodeId)

            } else if (nextCharacterSet == 5) {

                if (episode.isSixthCharacterPresent && characterSelection(chapter.characterSixName) == null)
                    return nextCharacterSet
                else
                    return nextCharacterSet(nextCharacterSet, chapterId, episodeId)

            } else if (nextCharacterSet == 6) {

                if (episode.isSeventhCharacterPresent && characterSelection(chapter.characterSevenName) == null)
                    return nextCharacterSet
                else
                    return null

            } else if (nextCharacterSet == 0) {

                if (episode.isFirstCharacterPresent && characterSelection(chapter.characterOneName) == null)
                    return nextCharacterSet
                else
                    return nextCharacterSet(nextCharacterSet, chapterId, episodeId)

            } else
                return null


        }


    }




    fun saveCharacterSelection(characterSelect: CharacterSelect){

        realm.executeTransaction { realm ->

            realm.copyToRealmOrUpdate(characterSelect)

        }

    }

    fun removeCharacterSelection(name: String){

        realm.executeTransaction { realm ->

            realm.where<CharacterSelect>().equalTo("name", name).findAll().deleteAllFromRealm()

        }

    }
    fun characterSelection(name :String): CharacterSelect? {

        return realm.where<CharacterSelect>().equalTo("name", name).findFirst()

    }

    fun resetCharacterSelection(){

        realm.executeTransaction { realm ->

            realm.where<CharacterSelect>().findAll().deleteAllFromRealm()
            realm.where<Bookmark>().findAll().deleteAllFromRealm()
            realm.where<TextClipping>().findAll().deleteAllFromRealm()

        }

    }

    fun shouldReset(): Boolean {

        val setting = realm.where<Setting>().findFirst()
        val currentLanguage = LocaleHelper.getLocale()


        if ( setting == null  || setting.language != currentLanguage) {
            realm.executeTransaction {
                realm.where<Setting>().findAll().deleteAllFromRealm()
                realm.copyToRealm(Setting(currentLanguage))
            }
            return true
        }


        return false



    }

    fun chapterBefore(chapterId: Int, episodeId: Int): Int?{

        if (isFirstEpisode(chapterId, episodeId) ) {

            return if ( isFirstChapter(chapterId) )
                null
            else {
                chapters[chapters.indexOf(chapter(chapterId)) - 1].id
            }


        } else {
            return chapterId

        }


    }

    fun chapterAfter(chapterId: Int, episodeId: Int): Int?{

        if (isLastEpisode(chapterId, episodeId) ) {

            return if ( isLastChapter(chapterId) )
                null
            else {
                chapters[chapters.indexOf(chapter(chapterId)) + 1].id
            }


        } else {
            return chapterId

        }


    }

//    fun episodeAfter(chapterId: Int, episodeId: Int): Int{
//
//        return if ( isLastEpisode(chapterId, episodeId) ) chapter() else chapterId
//
//    }

    private fun isLastEpisode(chapterId: Int, episodeId: Int): Boolean{

        return episodeId == chapters.first { it.id == chapterId }.episodes.last()?.id
    }

    private fun isLastChapter(chapterId: Int): Boolean{

        return chapterId == chapters.last().id
    }

    private fun isFirstEpisode(chapterId: Int, episodeId: Int): Boolean{

        return episodeId == chapters.first { it.id == chapterId }.episodes.first()?.id
    }

    private fun isFirstChapter(chapterId: Int): Boolean{

        return chapterId == chapters.first().id
    }

    fun episodeBefore(chapterId: Int, episodeId: Int): Int? {

        if ( isFirstEpisode(chapterId, episodeId) ){

            val prevChapterId = chapterBefore(chapterId, episodeId)
            if ( prevChapterId == null )
                return null
            else {
                val chapter = chapter(prevChapterId)
                return chapter?.episodes?.last()?.id
            }

        } else {
            val chapter = chapter(chapterId)
            return chapter?.episodes?.get(chapter.episodes.indexOf(chapter.episodes.first { it.id == episodeId }) - 1)?.id

        }




    }

    fun episodeAfter(chapterId: Int, episodeId: Int): Int? {

        if ( isLastEpisode(chapterId, episodeId) ){

            val nextChapterId = chapterAfter(chapterId, episodeId)
            if ( nextChapterId == null )
                return null
            else {
                val chapter = chapter(nextChapterId)
                return chapter?.episodes?.first()?.id
            }

        } else {
            val chapter = chapter(chapterId)
            return chapter?.episodes?.get(chapter.episodes.indexOf(chapter.episodes.first { it.id == episodeId }) + 1)?.id

        }




    }

    fun firstChapterId(): Int{
        return chapters.first().id
    }

    fun firstEpisodeId(): Int? {
        return chapter(firstChapterId()).episodes.first()?.id
    }

    fun updateBookmarkPosition(position: Int): Bookmark?{
        realm.executeTransaction {
            val bookmark = realm.where<Bookmark>().findFirst()

            if(bookmark != null) {
                bookmark.position = position
                realm.copyToRealmOrUpdate(bookmark)
                _bookmark = bookmark
            }
        }

        return realm.copyFromRealm(realm.where<Bookmark>().findFirst())


    }


}