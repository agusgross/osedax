//
//  PersistenceAssembly.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/14/21.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import RealmSwift

class PersistenceAssembly: Assembly {

    func assemble(container: Container) {
        
        container.register(Realm.self) { r in
            try! Realm()
        }.inObjectScope(.container)

        container.register(ChapterStore.self) { r in
            ChapterStore(realm: r.resolve(Realm.self)!)
        }.inObjectScope(.container)

//        container.register(NetworkProvider.self) { r in
//            NetworkProvider(baseURL: URL(string: r.resolve(Config.self)!.readFromConfigurationFile(key: "BaseUrl")!)!)
//        }.inObjectScope(.container)

    }
}
