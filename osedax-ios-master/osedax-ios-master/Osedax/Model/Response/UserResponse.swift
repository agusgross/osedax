//
//  UserResponse.swift
//  Ambulancias
//
//  Created by Gustavo Rago on 1/14/21.
//  Copyright © 2021 Gustavo Rago. All rights reserved.
//

import Foundation

class UserResponse: Decodable {
    
    var ok: Bool
    var user: User?

    enum CodingKeys: String, CodingKey {
        case ok = "ok"
        case user = "user"
        
    }
    
    required init(from decoder: Decoder) throws  {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ok = try values.decode(Bool.self, forKey: .ok)
        self.user = try values.decodeIfPresent(User.self, forKey: .user)
        
    }
    
}
