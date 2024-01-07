//
//  NetworkAssembly.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import Heimdallr

class NetworkAssembly: Assembly {

    func assemble(container: Container) {
        
        container.register(NetworkProvider.self) { r in
            NetworkProvider(baseURL: URL(string: r.resolve(Config.self)!.readFromConfigurationFile(key: "BaseUrl")! + "api/")!, imagesUrl: URL(string: r.resolve(Config.self)!.readFromConfigurationFile(key: "ImagesUrl")!)!, heimdallr: r.resolve(Heimdallr.self)!)
        }.inObjectScope(.container)
      
        container.register(Heimdallr.self) { r in

            let config = r.resolve(Config.self)!
            
            let tokenURL = URL(string: (config.readFromConfigurationFile(key: "BaseUrl") ?? "") + "oauth/v2/token")!
            let credentials = OAuthClientCredentials(id: config.readFromConfigurationFile(key: "ClientId")!, secret: config.readFromConfigurationFile(key: "ClientSecret")!)
            
            return Heimdallr(tokenURL: tokenURL, credentials: credentials)

        }.inObjectScope(.container)

//        container.register(NetworkProvider.self) { r in
//            NetworkProvider(baseURL: URL(string: r.resolve(Config.self)!.readFromConfigurationFile(key: "BaseUrl")!)!)
//        }.inObjectScope(.container)

    }
}

