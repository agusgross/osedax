//
//  CharacterSelectViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/5/21.
//

import UIKit

class CharacterSelectViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        dataSource = parent as? CharactersViewController
        delegate = parent as? CharactersViewController
    }
}
