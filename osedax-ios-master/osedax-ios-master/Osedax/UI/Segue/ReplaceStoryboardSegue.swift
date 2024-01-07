//
//  ReplaceStoryboardSegue.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/26/21.
//

import UIKit

class ReplaceStoryBoardSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let navigationViewController = source as? UINavigationController ?? source.navigationController
        
        
        navigationViewController?.viewControllers.removeLast()
        navigationViewController?.pushViewController(self.destination, animated: true)
        
        
        
    }
    
}
