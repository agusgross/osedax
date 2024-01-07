//
//  Button.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/13/21.
//

import UIKit

@IBDesignable
class Button: UIButton  {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        
//        layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowRadius = 4
//        layer.shadowOpacity = 0.4


        titleLabel?.font = titleLabel?.font.withSize(titleLabel?.font.pointSize ?? 18)

    }
    
    @IBInspectable
    var leftTitleInsetForAlt: CGFloat = -12 {
        didSet {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: leftTitleInsetForAlt, bottom: 0, right: 0)
        }
    }
    
    @IBInspectable
    var isAlt: Bool = false {
        didSet {
            
            if isAlt {
                layer.borderWidth = 0
                backgroundColor = UIColor(named: "ColorAccent")
                tintColor = UIColor.red
                imageView?.tintColor = UIColor.black
                setTitleColor(UIColor.black, for: .normal)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: leftTitleInsetForAlt, bottom: 0, right: 0)
                
                

            } else {
                layer.borderWidth = 2.0
                layer.borderColor = UIColor(named: "ColorAccent")?.cgColor
                backgroundColor = .clear
                tintColor = UIColor(named: "ColorAccent")
                imageView?.tintColor = UIColor(named: "ColorAccent")
                setTitleColor(UIColor.white, for: .normal)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

            }
        }
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
//                imageView.tintColor = UIColor(named: "ColorAccent")
                self.bringSubviewToFront(imageView)
                
            }
            
            self.titleLabel?.sizeToFit()
            
        }
    }
    
    
    func setImageInsets(){
        
        guard let leftImage = leftImage else {
            return
        }

        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 12 , bottom: 0, right: 0 )

    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
//        contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 38)
    }
  
    var _uppercased = true
    @IBInspectable var uppercased: Bool = true {
        didSet {
            _uppercased = uppercased
        }
    }
    
    override var isUppercased: Bool {
        return _uppercased
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return leftImage != nil ? (titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)) : titleRect
    }
    
    public func setTintColorForImage(_ color: UIColor){
        imageView?.tintColor = color
    }
}
