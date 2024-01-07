//
//  HelperAssembly.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import UIKit
import Swinject

class HelperAssembly: Assembly {

    func assemble(container: Container) {
        
        container.autoregister(Config.self, initializer: Config.init).inObjectScope(.container)


    }
}
