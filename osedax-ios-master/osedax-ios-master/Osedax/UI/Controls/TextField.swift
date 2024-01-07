//
//  TextField.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/17/21.
//

import UIKit

@IBDesignable
class TextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(named: "ColorAccent")?.cgColor
         
        tintColor = UIColor(named: "ColorAccent")
        
        textColor = UIColor.white
        
        font = UIFont(name: "Helvetica", size: 14)
        
    }
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor(named: "ColorHint")!] )



        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
    }
    
}
