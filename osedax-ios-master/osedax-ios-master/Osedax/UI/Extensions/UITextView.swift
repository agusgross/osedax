//
//  UITextField.swift
//  Osedax
//
//  Created by Gustavo Rago on 6/7/21.
//

import UIKit

class NoSelectTextField: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        tintColor = UIColor.init(named: "ColorAccent")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = UIColor.init(named: "ColorAccent")
    }

    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) ||
            action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) ||
            action == #selector(select(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(delete(_:)) ||
            action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
            action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
            action == #selector(toggleBoldface(_:)) ||
            action == #selector(toggleItalics(_:)) ||
            action == Selector(("_lookup:")) ||
            action == Selector(("_share:")) ||
            action == Selector(("_define:")) ||
            action == Selector(("_translate:")) ||
            action == #selector(toggleUnderline(_:)) {
            

            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    @available(iOS 13, *)
    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
          return .none
      }

}
