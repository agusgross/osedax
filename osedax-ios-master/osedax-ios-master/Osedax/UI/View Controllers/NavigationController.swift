//
//  NavigationController.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/8/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
                
        return visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
        
         
    }
    
    override var shouldAutorotate: Bool {
        return visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    
}
