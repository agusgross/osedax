//
//  ChapterStore.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/14/21.
//

import Foundation
import RealmSwift

class ChapterStore {

    let realm: Realm

    private var _chapters: [Chapter]?
    
    public init(realm: Realm){
        
        self.realm = realm
        
    }


    var chapters: [Chapter]  {
        get {
        
            if _chapters == nil  {
                _chapters = [Chapter]()
                _chapters?.append(contentsOf: realm.objects(Chapter.self))
            }
            
            return _chapters!
        
        }
        
        set {
        
            _chapters = newValue
            
            try! realm.write{
                realm.delete(realm.objects(Chapter.self))
                realm.delete(realm.objects(Episode.self))
                newValue.forEach {  realm.add($0, update: .all)  }
                
            }
            
        }
    }

    func appendNewChapter(chapter: Chapter) {
        
        try! realm.write {
            
//            let chapterInDb = realm.objects(Chapter.self).filter("id = \(chapter.id)").first
            
//            if chapterInDb == nil {
                realm.add(chapter, update: .all)
//            }
            
            _chapters = []
            _chapters?.append(contentsOf: realm.objects(Chapter.self))
            
        }
    }
    
    func addChapter(chapter: Chapter) {
        
        try! realm.write {
            
            let chapterInDb = realm.objects(Chapter.self).filter("id = \(chapter.id)").first
            chapterInDb?.purchased = true
            
            for episode in chapter.episodes {
                let episodeInDb = realm.objects(Episode.self).filter("id = \(episode.id)").first
                
                episodeInDb?.text = episode.text
                episodeInDb?.text2 = episode.text2
                episodeInDb?.image = episode.image

            }
            
            _chapters = []
            _chapters?.append(contentsOf: realm.objects(Chapter.self))
            
            
            
        }
    }
    
    func saveTextClipping(text: String, indexStart: Int, indexEnd: Int, episode: Episode, chapter: Chapter, paragraph: Int, position: Int, characterCode: String) -> TextClipping?{
                
        let id = ((realm.objects(TextClipping.self).max(ofProperty: "id") as Int?) ?? 0) + 1
        let textClipping = TextClipping(id: id, text: text, indexStart: indexStart, indexEnd: indexEnd, chapter: chapter, episode: episode, position: position, paragraph: paragraph, language: LocaleHelper.getLocale(), characterCode: characterCode)
        
        try! realm.write {
            realm.add(textClipping, update: .all)
        }
        
        return realm.objects(TextClipping.self).filter("id = \(id)").first
    }
    
    func saveTextClipping(textClipping: TextClipping) {
        
        let id = (realm.objects(TextClipping.self).max(ofProperty: "id") as Int?) ?? 0 + 1
        textClipping.id = id
        
        try! realm.write {
            realm.add(textClipping, update: .all)
        }
        
    }
    
    func getClippings(episode: Episode? = nil) -> [TextClipping] {
        
        var clippings = [TextClipping]()
        
        if let episode = episode {
            clippings.append(contentsOf: realm.objects(TextClipping.self).filter("episode.id = \(episode.id) AND language='\(LocaleHelper.getLocale())'"))
        } else {
            clippings.append(contentsOf: realm.objects(TextClipping.self).filter("language='\(LocaleHelper.getLocale())'"))
        }
        
        return clippings
        
        
    }
    
    func getClipping(clippingId: Int) -> TextClipping?{
        return realm.objects(TextClipping.self).filter("id = \(clippingId)").first
    }
    
    func deleteClipping(id: Int){
        try! realm.write {
            if let clipping = realm.objects(TextClipping.self).filter("id = \(id)").first {
                realm.delete(clipping)
            }
            
        }
    }
    
    private var _bookmark: Bookmark?
    var bookmark: Bookmark? {
        get {
            if _bookmark == nil {
                try! realm.write {
                    _bookmark = realm.objects(Bookmark.self).first
                }
            }
            
            return _bookmark
        }
        
        set {
            try! realm.write {
                guard let newValue = newValue else { return }
                realm.delete(realm.objects(Bookmark.self))
                realm.add(newValue, update: .all)
                _bookmark = newValue
            }
        }
    }
    
    func getEpisodeText(chapterId: Int, episodeId: Int) -> String{
        return episode(chapterId, episodeId).textByCharacters
    }
    
    func getEpisodeText2(chapterId: Int, episodeId: Int) -> String {
        return episode(chapterId, episodeId).text2ByCharacters
    }

    func getEpisodeTitle(chapterId: Int, episodeId: Int) -> String {


        return episode(chapterId, episodeId).title

    }

    func getChapterTitle(chapterId: Int) -> String {


        return chapter(chapterId).title

    }

    func getChapterNumber(chapterId: Int) -> Int {


        return chapters.firstIndex(of: chapter(chapterId)) ?? 0 + 1

    }

    func episode(_ chapterId: Int, _ episodeId: Int) -> Episode{

        return (chapters.first { $0.id == chapterId }?.episodes.first { $0.id == episodeId })!
    }

    func chapter(_ chapterId: Int) -> Chapter {

        
        return (chapters.first { $0.id == chapterId })!

    }
    
    func nextCharacterSet(currentCharacterSet: Int, chapterId: Int?, episodeId: Int?) -> Int?{

        let aChapter = chapterId != nil ? chapter(chapterId!) : chapter(firstChapterId())

        let n = aChapter.numberOfCharacters

        if  currentCharacterSet == n-1 { // if last characterset

            return nil

        } else {

            let anEpisode =  episodeId != nil ? episode(aChapter.id, episodeId!) : episode(aChapter.id, firstEpisodeId()!)


            let aNextCharacterSet = currentCharacterSet + 1
//
            if aNextCharacterSet == 1 {
                if anEpisode.isSecondCharacterPresent && characterSelection(name: aChapter.characterTwoName) == nil {
                    return aNextCharacterSet
                } else {
                    
                    return nextCharacterSet(currentCharacterSet: aNextCharacterSet, chapterId: chapterId, episodeId: episodeId)
                }

            } else if aNextCharacterSet == 2 {

                if anEpisode.isThirdCharacterPresent && characterSelection(name: aChapter.characterThreeName) == nil {
                    return aNextCharacterSet
                } else {
                    return nextCharacterSet(currentCharacterSet: aNextCharacterSet, chapterId: chapterId, episodeId: episodeId)
                }

            } else if aNextCharacterSet == 3 {

                if anEpisode.isFourthCharacterPresent && characterSelection(name: aChapter.characterFourName) == nil {
                    return aNextCharacterSet
                } else {
                    return nextCharacterSet(currentCharacterSet: aNextCharacterSet, chapterId: chapterId, episodeId: episodeId)
                }

            } else if aNextCharacterSet == 4 {

                if anEpisode.isFifthCharacterPresent && characterSelection(name: aChapter.characterFiveName) == nil {
                    return aNextCharacterSet
                } else {
                    return nextCharacterSet(currentCharacterSet: aNextCharacterSet, chapterId: chapterId, episodeId: episodeId)
                }
                
            } else if aNextCharacterSet == 5 {

                if anEpisode.isSixthCharacterPresent && characterSelection(name: aChapter.characterSixName) == nil {
                    return aNextCharacterSet
                } else {
                    return nextCharacterSet(currentCharacterSet: aNextCharacterSet, chapterId: chapterId, episodeId: episodeId)
                }

            } else if aNextCharacterSet == 6 {

                if anEpisode.isSeventhCharacterPresent && characterSelection(name: aChapter.characterSevenName) == nil {
                    return aNextCharacterSet
                } else {
                    return nil
                }

            } else if aNextCharacterSet == 0 {

                if anEpisode.isFirstCharacterPresent && characterSelection(name: aChapter.characterOneName) == nil {
                    return aNextCharacterSet
                } else {
                    return nextCharacterSet(currentCharacterSet: aNextCharacterSet, chapterId: chapterId, episodeId: episodeId)
                }

            } else {
                return nil
            }


        }


    }
    
    func saveCharacterSelection(characterSelect: CharacterSelect){

        try! realm.write {

            realm.add(characterSelect, update: .all)

        }

    }

    func removeCharacterSelection(name: String){

        try! realm.write {

            realm.delete(realm.objects(CharacterSelect.self).filter("name = '\(name)'"))

        }

    }
    
    
    
    func characterSelection(name :String) -> CharacterSelect? {

        return realm.objects(CharacterSelect.self).filter("name = '\(name)'").first

    }

    func resetCharacterSelection(){

        try! realm.write {
            realm.delete(realm.objects(CharacterSelect.self))
            realm.delete(realm.objects(Bookmark.self))
            realm.delete(realm.objects(TextClipping.self))
        }

    }

    func shouldReset() -> Bool {
        
        let currentLanguage = LocaleHelper.getLocale()
        let setting = realm.objects(Setting.self).first
        
        if setting?.language != currentLanguage {
            
            
            try! realm.write {
                realm.delete(realm.objects(Setting.self))
                realm.add(Setting(language: currentLanguage))
                
            }


            return true
        }
        
        return false
        
        
    }
    
    func chapterBefore(_ chapterId: Int, _ episodeId: Int) -> Int?{

        if isFirstEpisode(chapterId, episodeId)  {

            if  isFirstChapter(chapterId) {
                return nil
            } else {
                return chapters[chapters.firstIndex(of: chapter(chapterId)) ?? 0 - 1].id
            }


        } else {
            return chapterId

        }


    }
    
    func chapterAfter(_ chapterId: Int, _ episodeId: Int) -> Int?{

        if isLastEpisode(chapterId, episodeId)  {

            if isLastChapter(chapterId)  {
               return nil
            } else {
                return chapters[(chapters.firstIndex(of: chapter(chapterId)) ?? 0) + 1].id
            }


        } else {
            return chapterId

        }


    }

    private func isLastEpisode(_ chapterId: Int, _ episodeId: Int) -> Bool{

        return episodeId == chapters.first { $0.id == chapterId }?.episodes.last?.id
    }

    private func isLastChapter(_ chapterId: Int) -> Bool{

        return chapterId == chapters.last?.id
    }
    
    private func isFirstEpisode(_ chapterId: Int, _ episodeId: Int) -> Bool{

        return episodeId == chapters.first { $0.id == chapterId }?.episodes.first?.id
    }

    
    private func isFirstChapter(_ chapterId: Int) -> Bool{

        return chapterId == chapters.first?.id
    }
    
    func episodeBefore(_ chapterId: Int, _ episodeId: Int) -> Int? {

        if isFirstEpisode(chapterId, episodeId) {

            let prevChapterId = chapterBefore(chapterId, episodeId)
            if  prevChapterId == nil {
                return nil
            } else {
                let aChapter = chapter(prevChapterId!)
                return aChapter.episodes.last?.id
            }

        } else {
            let aChapter = chapter(chapterId)
            return aChapter.episodes[aChapter.episodes.firstIndex(of: aChapter.episodes.first { $0.id == episodeId }!) ?? 0 - 1].id

        }




    }

    func episodeAfter(_ chapterId: Int, _ episodeId: Int) -> Int? {

        if  isLastEpisode(chapterId, episodeId) {

            let nextChapterId = chapterAfter(chapterId, episodeId)
            if nextChapterId == nil {
                return nil
            } else {
                let aChapter = chapter(nextChapterId!)
                return aChapter.episodes.first?.id
            }

        } else {
            let aChapter = chapter(chapterId)
            return aChapter.episodes[(aChapter.episodes.firstIndex(of: aChapter.episodes.first { $0.id == episodeId }!) ?? 0) + 1].id

        }

    }
    
    
    
    func firstChapterId() -> Int{
        return chapters.first!.id
    }

    
    func firstEpisodeId() -> Int? {
        return chapter(firstChapterId()).episodes.first?.id
    }

    func updateBookmarkPosition(position: Int) -> Bookmark?{
        try! realm.write {
            if let bookmark = realm.objects(Bookmark.self).first {
                bookmark.position = position
                realm.add(bookmark)
                _bookmark = bookmark
            }
        }

        return realm.objects(Bookmark.self).first


    }


}
