//
//  CAGradientLayer.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/8/21.
//

import UIKit

extension CAGradientLayer {

    convenience init(colors: [UIColor]) {
        self.init()

        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        
        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
    }
    
    convenience init(frame: CGRect, colors: [UIColor]) {

        self.init(colors: colors)
        self.frame = frame
        
        
    }
    
    func createGradientImage() -> UIImage? {
                
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
