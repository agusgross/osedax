//
//  RestResponse.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/16/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation

public class RestResponse: Decodable {
    
    var ok = false
    var errors = [ErrorResponse]()
    
    enum CodingKeys: String, CodingKey {
        case ok = "ok"
        case errors = "errors"
        
    }
    
    required public init(from decoder: Decoder) throws  {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ok = try values.decode(Bool.self, forKey: .ok)
        self.errors = ((try? values.decodeIfPresent([ErrorResponse].self, forKey: .errors)) ?? [])
        
    }
    
    public func getError() -> String {
        

        return errors.reduce("") { "\($0)\($1.message.localized)\n" }
    }

    
}
