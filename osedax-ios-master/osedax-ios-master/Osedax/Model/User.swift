//
//  User.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation

public class User: Codable {
    
    public static var currentUser: User?
    
    var id: UInt32?
    var email: String?
    var firstName: String?
    var lastName: String?
    var plainPassword: String?
    var emailNotifications: Bool? = false

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case documentNumber = "document_number"
        case address = "address"
        case mobileNumber = "mobile_number"
        case plainPassword = "plain_password"
        case emailNotifications = "email_notifications"
        
    }
    
    init() {
    }
    
    public required init(from decoder: Decoder) throws  {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        self.id = try? values?.decodeIfPresent(UInt32.self, forKey: .id)
        self.email = try? values?.decodeIfPresent(String.self, forKey: .email)
        self.firstName = try? values?.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try? values?.decodeIfPresent(String.self, forKey: .lastName)
        self.plainPassword = try? values?.decodeIfPresent(String.self, forKey: .plainPassword)
        self.emailNotifications = try? values?.decodeIfPresent(Bool.self, forKey: .emailNotifications)
                
        
    }

    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        
        
            
        try? container.encodeIfPresent(id, forKey: .id)
        try? container.encodeIfPresent(firstName, forKey: .firstName)
        try? container.encodeIfPresent(lastName, forKey: .lastName)
        try? container.encodeIfPresent(email, forKey: .email)
        try? container.encodeIfPresent(plainPassword, forKey: .plainPassword)
        try? container.encodeIfPresent(emailNotifications, forKey: .emailNotifications)
    }


}
