//
//  Episode.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation
import RealmSwift

@objcMembers class Episode: Object, Codable {
    dynamic var id = 0
    dynamic var title = ""
    dynamic var text = ""
    dynamic var text2 = ""
    dynamic var textByCharacters = ""
    dynamic var text2ByCharacters = ""
    dynamic var image = ""
    dynamic var isFirstCharacterPresent = false
    dynamic var isSecondCharacterPresent = false
    dynamic var isThirdCharacterPresent = false
    dynamic var isFourthCharacterPresent = false
    dynamic var isFifthCharacterPresent = false
    dynamic var isSixthCharacterPresent = false
    dynamic var isSeventhCharacterPresent = false
    dynamic var episodeNumber = 0

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case text = "text"
        case text2 = "text2"
        case textByCharacters = "text_by_characters"
        case text2ByCharacters = "text2_by_characters"
        case image = "image"
        case isFirstCharacterPresent = "is_first_character_present"
        case isSecondCharacterPresent = "is_second_character_present"
        case isThirdCharacterPresent = "is_third_character_present"
        case isFourthCharacterPresent = "is_fourth_character_present"
        case isFifthCharacterPresent = "is_fifth_character_present"
        case isSixthCharacterPresent = "is_sixth_character_present"
        case isSeventhCharacterPresent = "is_seventh_character_present"
        case episodeNumber = "episode_number"

    }
    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws  {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        self.id = try! values.decode(Int.self, forKey: .id)
        self.title = (try? values.decode(String.self, forKey: .title)) ?? ""
        self.text = (try? values.decode(String.self, forKey: .text)) ?? ""
        self.text2 = (try? values.decode(String.self, forKey: .text2)) ?? ""
        self.textByCharacters = (try? values.decode(String.self, forKey: .textByCharacters)) ?? ""
        self.text2ByCharacters = (try? values.decode(String.self, forKey: .text2ByCharacters)) ?? ""
        self.image = (try? values.decode(String.self, forKey: .image)) ?? ""
        self.isFirstCharacterPresent = (try? values.decode(Bool.self, forKey: .isFirstCharacterPresent)) ?? false
        self.isSecondCharacterPresent = (try? values.decode(Bool.self, forKey: .isSecondCharacterPresent)) ?? false
        self.isThirdCharacterPresent = (try? values.decode(Bool.self, forKey: .isThirdCharacterPresent)) ?? false
        self.isFourthCharacterPresent = (try? values.decode(Bool.self, forKey: .isFourthCharacterPresent)) ?? false
        self.isFifthCharacterPresent = (try? values.decode(Bool.self, forKey: .isFifthCharacterPresent)) ?? false
        self.isSixthCharacterPresent = (try? values.decode(Bool.self, forKey: .isSixthCharacterPresent)) ?? false
        self.isSeventhCharacterPresent = (try? values.decode(Bool.self, forKey: .isSeventhCharacterPresent)) ?? false
        self.episodeNumber = (try? values.decode(Int.self, forKey: .episodeNumber)) ?? 0
        
        
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(id, forKey: .id)
    }

    override class func primaryKey() -> String? {
        return "id"
    }

}
