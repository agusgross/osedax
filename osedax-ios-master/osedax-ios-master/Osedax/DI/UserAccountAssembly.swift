//
//  UserAccountAssembly.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import Heimdallr

class UserAccountAssembly: Assembly {

    func assemble(container: Container) {
                        
        container.register(UserManager.self) { r in
            UserManager(networkProvider: r.resolve(NetworkProvider.self)!, tokenProvider: r.resolve(Heimdallr.self)!)
        }.inObjectScope(.container)
    }
}

