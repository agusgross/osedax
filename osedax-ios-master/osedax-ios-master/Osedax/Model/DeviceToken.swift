//
//  DeviceToken.swift
//  Ambulancias
//
//  Created by Gustavo Rago on 10/31/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Alamofire

public class DeviceToken: Encodable, ParameterEncoding {
    
    let deviceType: String? = "ios"
    var deviceId: String?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        
        case deviceType = "device_type"
        case deviceId = "device_id"
        case token = "token"
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(deviceType, forKey: .deviceType)
        try container.encode(deviceId, forKey: .deviceId)
        try container.encode(token, forKey: .token)
        
        
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        
        var request = try URLEncoding(destination: .queryString).encode(urlRequest, with: parameters)
        
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(self)
        
        return request
        
    }
    
    
}


