//
//  DialogHelper.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/20/21.
//

import UIKit

class DialogHelper {
    
    static func showDialog(_ vc: UIViewController?, title: String, text: String, okButton: String, completion: (() -> Void)? = nil ){
    
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButton, style: .default){ _  in
            completion?()
        })
         
        
        vc?.present(alertController, animated: true, completion: nil)



    }

    static func showDialog(_ vc: UIViewController?, title: String, text: String, okButton: String, cancelButon: String, completion: (() -> Void)? = nil ){
    
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButton, style: .destructive){ _  in
            completion?()
        })
        alertController.addAction(UIAlertAction(title: cancelButon, style: .cancel))

        
        vc?.present(alertController, animated: true, completion: nil)

    }

}
