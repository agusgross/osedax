//
//  ErrorResponse.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/16/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation

class ErrorResponse: Decodable {
    
    var message: String

    enum CodingKeys: String, CodingKey {
        case message = "message"
        
    }
    
    required init(from decoder: Decoder) throws  {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try values.decode(String.self, forKey: .message)
        
    }
    
}
