//
//  DependencyProvider.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class DependencyProvider {

    let assembler: Assembler

    
    init() {
        
        assembler = Assembler(
            [
                HelperAssembly(),
                NetworkAssembly(),
                UserAccountAssembly(),
                PersistenceAssembly(),
            ],
            container: SwinjectStoryboard.defaultContainer
        )
    }
}

