//
//  Bookmark.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation
import RealmSwift

@objcMembers class Bookmark: Object, Codable {
    dynamic var id = 0
    dynamic var chapter: Chapter?
    dynamic var episode: Episode?
    dynamic var position = 0
    dynamic var characterCode = ""

    enum CodingKeys: String, CodingKey {
        
        case chapter = "chapter"
        case episode = "episode"
        case position = "position"

    }
    
    override init(){
        super.init()
        
    }

    required init(from decoder: Decoder) throws  {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        self.chapter = try! values.decode(Chapter.self, forKey: .chapter)
        self.episode = try! values.decode(Episode.self, forKey: .episode)
        self.position = try! values.decode(Int.self, forKey: .position)
    }
    
    convenience init(chapter: Chapter, episode: Episode){
        self.init()
        
        self.chapter = chapter
        self.episode = episode
    }

    convenience init(chapter: Chapter, episode: Episode, position: Int){
        self.init()
        
        self.chapter = chapter
        self.episode = episode
        self.position = position
    }

    convenience init(chapter: Chapter, episode: Episode, position: Int, characterCode: String){
        self.init()
        
        self.chapter = chapter
        self.episode = episode
        self.position = position
        self.characterCode = characterCode
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(chapter, forKey: .chapter)
        try? container.encode(episode, forKey: .episode)
        try? container.encode(position, forKey: .position)
    }

    override class func primaryKey() -> String? {
        return "id"
    }

}
