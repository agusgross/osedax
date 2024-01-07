//
//  ButtonSmall.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/17/21.
//

import UIKit

@IBDesignable
class ButtonSmall: UIButton  {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        
        layer.borderWidth = 0
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        tintColor = UIColor.white

    }
        

    @IBInspectable
    var leftImage: UIImage? {
        didSet {

            guard let leftImage = leftImage else {
                return
            }

            self.setImage(leftImage.withRenderingMode(.alwaysTemplate), for: .normal)
//            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: leftImage.size.width/2 , bottom: 0, right: 0)
            self.setImageInsets()
//            self.contentHorizontalAlignment = .left

            if let imageView = self.imageView {

                imageView.contentMode = .center
                imageView.tintColor = UIColor.white
                self.bringSubviewToFront(imageView)

            }

            self.titleLabel?.sizeToFit()

        }
    }

    
    func setImageInsets(){

        guard let leftImage = leftImage else {
            return
        }

        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12 , bottom: 0, right: 0 )

    }
    

    
    override var isUppercased: Bool {
        false
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
}
