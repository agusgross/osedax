//
//  Config.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation

struct Config {

    init() {
        
    }
    
    func readFromConfigurationFile<T>(key: String, file: String = "Config") -> T?  {
        
        guard let path = Bundle.main.path(forResource: file, ofType: "plist")  else {
            
            return nil
        }
        
        return NSDictionary(contentsOfFile: path)?[key] as? T
        
        
        
        
    }
    
    func imagesUrl() -> String {
            
        return self.readFromConfigurationFile(key: "ImagesUrl")! + "/imgs"
        
    }
    
    func subscribeUrl() -> String {
            
        return self.readFromConfigurationFile(key: "MercureUrl")!
        
    }

    
    
}

