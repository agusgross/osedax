//
//  ProfileIconView.swift
//  Osedax
//
//  Created by Gustavo Rago on 6/9/21.
//

import UIKit

class ProfileIconView: UIView {
        
    let iv = UIImageView(image: #imageLiteral(resourceName: "ic_person").withRenderingMode(.alwaysTemplate))
    let iv2 = UIImageView(image: #imageLiteral(resourceName: "ic_drawer_close").withRenderingMode(.alwaysTemplate))
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        
        iv.tintColor = .white
        iv.frame = bounds
        addSubview(iv)
        
        iv2.tintColor = .white
        iv2.frame = bounds
        iv2.alpha = 0
        addSubview(iv2)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
        

    func startAnimation(){

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.iv.alpha = 0
            self?.iv2.alpha = 1
        } completion: { [weak self] _ in
            self?.iv.alpha = 0
            self?.iv2.alpha = 1
        }

        

    }

    func startCloseAnimation(){

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.iv.alpha = 1
            self?.iv2.alpha = 0
        } completion: { [weak self] _ in
            self?.iv.alpha = 1
            self?.iv2.alpha = 0
        }


    }


}
