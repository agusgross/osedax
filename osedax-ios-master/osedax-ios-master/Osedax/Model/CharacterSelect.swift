//
//  CharacterSelect.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation
import RealmSwift

@objcMembers class CharacterSelect: Object, Codable {
    dynamic var name = ""
    dynamic var option = 0

    override init() {
        
    }
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case option = "character_option"
    
    }

    init(name: String, option: Int){
        self.name = name
        self.option = option
        
    }

    required init(from decoder: Decoder) throws  {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        self.name = try! values.decode(String.self, forKey: .name)
        self.option = try! values.decode(Int.self, forKey: .option)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(name, forKey: .name)
        try? container.encode(option, forKey: .option)
    }

    override class func primaryKey() -> String? {
        return "name"
    }

}
