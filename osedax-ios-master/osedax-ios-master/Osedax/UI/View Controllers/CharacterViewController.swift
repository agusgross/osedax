//
//  CharacterViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/5/21.
//

import UIKit
import Kingfisher

class CharacterViewController: UIViewController {
    
    var config: Config?
    
    var character = "character_1_f" {
        didSet {
         
            guard let imagesUrl = config?.imagesUrl() else { return }
            
            imageView?.kf.setImage(with: URL(string: imagesUrl + "/" + character + ".jpg"))

            
        }
    }
    
    var position = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }

    private func setupUI(){
        
        guard let imagesUrl = config?.imagesUrl() else { return }
        
        imageView?.kf.setImage(with: URL(string: imagesUrl + "/" + character + ".jpg"))

        
    }
    

}
