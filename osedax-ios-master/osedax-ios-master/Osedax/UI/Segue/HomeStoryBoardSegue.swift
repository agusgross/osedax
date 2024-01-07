//
//  HomeStoryboardSegue.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/24/21.
//

import UIKit

class HomeStoryBoardSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let navigationViewController = source as? UINavigationController ?? source.navigationController
        
        navigationViewController?.viewControllers.removeAll()
        navigationViewController?.pushViewController(destination, animated: true)
        
    }
    
}
