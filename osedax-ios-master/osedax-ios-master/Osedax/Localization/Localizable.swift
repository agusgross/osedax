//
//  Localizable.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/13/21.
//

import UIKit

protocol Localizable {
    var localized: String { get }
}
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

@objc protocol XIBLocalizable {
    var isUppercased: Bool { get }
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
    var isUppercased: Bool {
        false
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(isUppercased ? key?.localized.uppercased() : key?.localized, for: .normal)
            
        }
   }
    
    var isUppercased: Bool {
        false
    }
    
}

extension UITextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            
            placeholder = key?.localized
            
        }
   }
    
    var isUppercased: Bool {
        false
    }
    
}






