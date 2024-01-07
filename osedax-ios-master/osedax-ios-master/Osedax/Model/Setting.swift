//
//  Setting.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/15/21.
//

import Foundation
import RealmSwift

class Setting: Object {
    @objc dynamic var language = ""
    
    override init() {
        super.init()
    }
    
    init(language: String){
        super.init()
        self.language = language
        
    }

}
