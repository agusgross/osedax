//
//  NavigationBar.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/19/21.
//

import UIKit

class NavigationBar: UINavigationBar {

    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
                
    }
    
    private func setupUI(){
        
        removeBackgroundGradient()
        addLogo()
        
    }
    
    func addLogo(){

        if logoImageView.superview == nil {
            logoImageView.contentMode = .scaleAspectFit
            addSubview(logoImageView)
        }
    }

    public func removeBackgroundGradient(){
        
       self.setBackgroundImage(UIImage(), for: .default)
       self.shadowImage = UIImage()
       self.isTranslucent = true
       self.backgroundColor = .clear
       if #available(iOS 13.0, *) {
           self.standardAppearance.backgroundColor = .clear
//               self.standardAppearance.backgroundEffect = .none
//               self.standardAppearance.shadowColor = .clear
       }

    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView.center = CGPoint(x: frame.width  / 2 , y: frame.height / 2 - 5 )
        
        
    }
    
}
