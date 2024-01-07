//
//  Chapter.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation
import RealmSwift

@objcMembers class Chapter: Object, Codable {
    dynamic var id = 0
    dynamic var title = ""
    let episodes = RealmSwift.List<Episode>()
    dynamic var purchased = false
    dynamic var numberOfCharacters = 0
    dynamic var characterOneOptionA = ""
    dynamic var characterOneOptionB = ""
    dynamic var characterTwoOptionA = ""
    dynamic var characterTwoOptionB = ""
    dynamic var characterThreeOptionA = ""
    dynamic var characterThreeOptionB = ""
    dynamic var characterFourOptionA = ""
    dynamic var characterFourOptionB = ""
    dynamic var characterFiveOptionA = ""
    dynamic var characterFiveOptionB = ""
    dynamic var characterSixOptionA = ""
    dynamic var characterSixOptionB = ""
    dynamic var characterSevenOptionA = ""
    dynamic var characterSevenOptionB = ""
    dynamic var characterOneName = ""
    dynamic var characterTwoName = ""
    dynamic var characterThreeName = ""
    dynamic var characterFourName = ""
    dynamic var characterFiveName = ""
    dynamic var characterSixName = ""
    dynamic var characterSevenName = ""
    dynamic var sku = ""

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case episodes = "episodes"
        case purchased = "purchased"
        case numberOfCharacters = "number_of_characters"
        case characterOneOptionA = "character_one_option_a"
        case characterOneOptionB = "character_one_option_b"
        case characterTwoOptionA = "character_two_option_a"
        case characterTwoOptionB = "character_two_option_b"
        case characterThreeOptionA = "character_three_option_a"
        case characterThreeOptionB = "character_three_option_b"
        case characterFourOptionA = "character_four_option_a"
        case characterFourOptionB = "character_four_option_b"
        case characterFiveOptionA = "character_five_option_a"
        case characterFiveOptionB = "character_five_option_b"
        case characterSixOptionA = "character_six_option_a"
        case characterSixOptionB = "character_six_option_b"
        case characterSevenOptionA = "character_seven_option_a"
        case characterSevenOptionB = "character_seven_option_b"
        case characterOneName = "character_one_name"
        case characterTwoName = "character_two_name"
        case characterThreeName = "character_three_name"
        case characterFourName = "character_four_name"
        case characterFiveName = "character_five_name"
        case characterSixName = "character_six_name"
        case characterSevenName = "character_seven_name"
        case sku = "sku"
        
    }
    
    override init(){
        super.init()
        
    }
    
    required init(from decoder: Decoder) throws  {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        self.id = try! values.decode(Int.self, forKey: .id)
        self.title = (try? values.decode(String.self, forKey: .title)) ?? ""
        self.purchased = (try? values.decode(Bool.self, forKey: .purchased)) ?? false
        self.numberOfCharacters = (try? values.decode(Int.self, forKey: .numberOfCharacters)) ?? 0
        self.characterOneOptionA = (try? values.decode(String.self, forKey: .characterOneOptionA)) ?? ""
        self.characterOneOptionB = (try? values.decode(String.self, forKey: .characterOneOptionB)) ?? ""
        self.characterTwoOptionA = (try? values.decode(String.self, forKey: .characterTwoOptionA)) ?? ""
        self.characterTwoOptionB = (try? values.decode(String.self, forKey: .characterTwoOptionB)) ?? ""
        self.characterThreeOptionA = (try? values.decode(String.self, forKey: .characterThreeOptionA)) ?? ""
        self.characterThreeOptionB = (try? values.decode(String.self, forKey: .characterThreeOptionB)) ?? ""
        self.characterFourOptionA = (try? values.decode(String.self, forKey: .characterFourOptionA)) ?? ""
        self.characterFourOptionB = (try? values.decode(String.self, forKey: .characterFourOptionB)) ?? ""
        self.characterFiveOptionA = (try? values.decode(String.self, forKey: .characterFiveOptionA)) ?? ""
        self.characterFiveOptionB = (try? values.decode(String.self, forKey: .characterFiveOptionB)) ?? ""
        self.characterSixOptionA = (try? values.decode(String.self, forKey: .characterSixOptionA)) ?? ""
        self.characterSixOptionB = (try? values.decode(String.self, forKey: .characterSixOptionB)) ?? ""
        self.characterSevenOptionA = (try? values.decode(String.self, forKey: .characterSevenOptionA)) ?? ""
        self.characterSevenOptionB = (try? values.decode(String.self, forKey: .characterSevenOptionB)) ?? ""
        self.characterOneName = (try? values.decode(String.self, forKey: .characterOneName)) ?? ""
        self.characterTwoName = (try? values.decode(String.self, forKey: .characterTwoName)) ?? ""
        self.characterThreeName = (try? values.decode(String.self, forKey: .characterThreeName)) ?? ""
        self.characterFourName = (try? values.decode(String.self, forKey: .characterFourName)) ?? ""
        self.characterFiveName = (try? values.decode(String.self, forKey: .characterFiveName)) ?? ""
        self.characterSixName = (try? values.decode(String.self, forKey: .characterSixName)) ?? ""
        self.characterSevenName = (try? values.decode(String.self, forKey: .characterSevenName)) ?? ""
        self.sku = (try? values.decode(String.self, forKey: .sku)) ?? ""
        
        let episodesList = (try? values.decode([Episode].self, forKey: .episodes)) ?? []
        episodes.append(objectsIn: episodesList)

        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encodeIfPresent(id, forKey: .id)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
