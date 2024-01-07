//
//  InitResponse.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/20/21.
//

import Foundation
public class InitResponse: Codable {
    
    let textClippings: [TextClipping]
    let bookmarks: [Bookmark]
    let characterSelects: [CharacterSelect]
    
    enum CodingKeys: String, CodingKey {
        case bookmarks = "bookmarks"
        case textClippings = "text_clippings"
        case characterSelects = "character_selects"
        
    }
    
    required public init(from decoder: Decoder) throws  {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.bookmarks = try values.decode([Bookmark].self, forKey: .bookmarks)
        self.textClippings = try values.decode([TextClipping].self, forKey: .textClippings)
        self.characterSelects = try values.decode([CharacterSelect].self, forKey: .characterSelects)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        

    }
    

    
}
