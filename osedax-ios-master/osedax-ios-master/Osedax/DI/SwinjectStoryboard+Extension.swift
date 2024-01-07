//
//  SwinjectStoryboard+Extension.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration


extension SwinjectStoryboard {
  @objc class func setup() {

    let _ = Assembler(
        [
            HelperAssembly(),
            NetworkAssembly(),
            UserAccountAssembly(),
            PersistenceAssembly()
        ],
        container: SwinjectStoryboard.defaultContainer
    )

    defaultContainer.storyboardInitCompleted(WelcomeViewController.self) { resolver, controller in
        controller.userManager = resolver ~> UserManager.self
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.config = resolver ~> Config.self
    }

    defaultContainer.storyboardInitCompleted(LoginViewController.self) { resolver, controller in
        controller.userManager = resolver ~> UserManager.self
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.config = resolver ~> Config.self
    }

    defaultContainer.storyboardInitCompleted(SignUpViewController.self) { resolver, controller in
        controller.userManager = resolver ~> UserManager.self
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.config = resolver ~> Config.self
    }
    defaultContainer.storyboardInitCompleted(RecoverViewController.self) { resolver, controller in
        controller.userManager = resolver ~> UserManager.self
    }
    defaultContainer.storyboardInitCompleted(MenuViewController.self) { resolver, controller in
        controller.chapterStore = resolver ~> ChapterStore.self
    }
    defaultContainer.storyboardInitCompleted(RightMenuViewController.self) { resolver, controller in
        controller.chapterStore = resolver ~> ChapterStore.self
    }

    defaultContainer.storyboardInitCompleted(PageViewController.self) { resolver, controller in
        controller.chapterStore = resolver ~> ChapterStore.self
    }
    defaultContainer.storyboardInitCompleted(CharactersViewController.self) { resolver, controller in
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.userManager = resolver ~> UserManager.self
    }
    defaultContainer.storyboardInitCompleted(CharacterViewController.self) { resolver, controller in
        controller.config = resolver ~> Config.self
    }
    defaultContainer.storyboardInitCompleted(IntroViewController.self) { resolver, controller in
        controller.config = resolver ~> Config.self
        controller.chapterStore = resolver ~> ChapterStore.self
    }
    defaultContainer.storyboardInitCompleted(ReadViewController.self) { resolver, controller in
        controller.userManager = resolver ~> UserManager.self
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.config = resolver ~> Config.self
    }
    defaultContainer.storyboardInitCompleted(ClippingsViewController.self) { resolver, controller in
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.userManager = resolver ~> UserManager.self
    }
    defaultContainer.storyboardInitCompleted(PurchasesViewController.self) { resolver, controller in
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.userManager = resolver ~> UserManager.self
        controller.config = resolver ~> Config.self
    }

    defaultContainer.storyboardInitCompleted(PurchaseViewController.self) { resolver, controller in
        controller.userManager = resolver ~> UserManager.self
        controller.chapterStore = resolver ~> ChapterStore.self
        controller.config = resolver ~> Config.self
    }
      defaultContainer.storyboardInitCompleted(PurchaseChapterViewController.self) { resolver, controller in
          controller.config = resolver ~> Config.self
          controller.chapterStore = resolver ~> ChapterStore.self
          controller.userManager = resolver ~> UserManager.self
      }


  }
    
    class func getCustomClass() -> UserManager? {
        defaultContainer.resolve(UserManager.self)
    }
}


