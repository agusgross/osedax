//
//  UIView+ReusableView.swift
//  Ambulancias
//
//  Created by Gustavo Rago on 7/9/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: ReusableView {
}

extension UICollectionViewCell: ReusableView{
    
}

extension UITableViewHeaderFooterView: ReusableView{
    
}


protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
        
    }
}

extension UITableView {
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibLoadableView {
        
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
        
    }
    
    func register<T: UITableViewCell>(_: T.Type)  {
        
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
        
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T  {
        
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue header/footer with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return header
        
        
    }
    
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type)  {
        
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
        
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T  {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
}

extension EpisodeTitleTableViewCell: NibLoadableView {}
extension ClippingTableViewCell: NibLoadableView {}
