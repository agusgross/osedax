//
//  UIView.swift
//  Ambulancias
//
//  Created by Gustavo Rago on 6/15/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import UIKit

protocol XibLoadable {
    associatedtype CustomViewType
    static func loadFromXib() -> CustomViewType
}

extension XibLoadable where Self: UIView {
    static func loadFromXib() -> Self {
        let nib = UINib(nibName: "\(self)", bundle: Bundle(for: self))
        guard let customView = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            // your app should crash if the xib doesn't exist
            preconditionFailure("Couldn't load xib for view: \(self)")
        }
        return customView
    }
}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
}
