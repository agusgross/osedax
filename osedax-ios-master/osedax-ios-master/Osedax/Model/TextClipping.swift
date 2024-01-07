//
//  TextClipping.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation
import RealmSwift

@objcMembers class TextClipping: Object, Codable {
    dynamic var id = 0
    dynamic var text = ""
    dynamic var indexStart = 0
    dynamic var indexEnd = 0
    dynamic var chapter: Chapter?
    dynamic var episode: Episode?
    dynamic var position = 0
    dynamic var paragraph = 0
    dynamic var language = ""
    dynamic var characterCode = ""

    enum CodingKeys: String, CodingKey {
        
        case id = "foreign_id"
        case text = "text"
        case indexStart = "index_start"
        case indexEnd = "index_end"
        case chapter = "chapter"
        case episode = "episode"
        case position = "position"
        case paragraph = "paragraph"
        case language = "language"
        case characterCode = "character_code"

    }
    
    override init(){
        super.init()
        
    }

    
    init(id: Int, text: String, indexStart: Int, indexEnd: Int, chapter: Chapter, episode: Episode, position: Int, paragraph: Int, language: String, characterCode: String) {
    
        
        self.id = id
        self.text = text
        self.indexStart = indexStart
        self.indexEnd = indexEnd
        self.chapter = chapter
        self.episode = episode
        self.position = position
        self.paragraph = paragraph
        self.language = language
        self.characterCode = characterCode
        
        
    }
    
    required init(from decoder: Decoder) throws  {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        self.text = try! values.decode(String.self, forKey: .text)
        self.indexStart = try! values.decode(Int.self, forKey: .indexStart)
        self.indexEnd = try! values.decode(Int.self, forKey: .indexEnd)
        self.chapter = try! values.decode(Chapter.self, forKey: .chapter)
        self.episode = try! values.decode(Episode.self, forKey: .episode)
        self.position = try! values.decode(Int.self, forKey: .position)
        self.paragraph = try! values.decode(Int.self, forKey: .paragraph)
        self.language = try! values.decode(String.self, forKey: .language)
        self.characterCode = (try? values.decode(String.self, forKey: .characterCode)) ?? ""
        
        
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(id, forKey: .id)
        try? container.encode(text, forKey: .text)
        try? container.encode(indexStart, forKey: .indexStart)
        try? container.encode(indexEnd, forKey: .indexEnd)
        try? container.encode(chapter, forKey: .chapter)
        try? container.encode(episode, forKey: .episode)
        try? container.encode(position, forKey: .position)
        try? container.encode(paragraph, forKey: .paragraph)
        try? container.encode(language, forKey: .language)
        try? container.encode(characterCode, forKey: .characterCode)
        
    }

    override class func primaryKey() -> String? {
        return "id"
    }

}
