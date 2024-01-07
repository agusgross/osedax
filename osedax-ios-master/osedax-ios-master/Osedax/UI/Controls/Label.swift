//
//  Label.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/25/21.
//

import UIKit

class Label: UILabel {

    @IBInspectable
    var letterSpacing: Double = 0

    override public var text: String? {
        didSet {
            self.addCharacterSpacing(letterSpacing)
        }
    }

    func addCharacterSpacing(_ kernValue: Double) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
