//
//  RecoverViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/25/21.
//

import UIKit

class RecoverViewController: UIViewController {
    
    var userManager: UserManager!
    
    @IBOutlet weak var emailAddressTextField: TextField!
    @IBOutlet weak var recoverPasswordButton: Button!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var scrollViewBottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)) )
        self.view.addGestureRecognizer(tapGesture)

        
    }
        
    @IBAction func recoverButtonTapped(_ sender: Any) {
        
        guard let email = emailAddressTextField.text, !email.isEmpty else { return }
        
        view?.firstResponder?.resignFirstResponder()
        
        enableUI(false)
        
        userManager.recover(email: email) { [weak self] response, error in
        
            DispatchQueue.main.async {

                let message: String
                if response?.ok == true {
                    message = "the_password_was_sent".localized
                } else {
                    message = "email_not_found".localized
                }

                DialogHelper.showDialog(self, title: "recover".localized, text: message.localized, okButton: "OK"){
                        self?.enableUI()
                }

            }

            
            
            
        }
        
        
    }
    
    
    private func enableUI(_ enable: Bool = true){
        
        recoverPasswordButton.isHidden = !enable
        
        if enable {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        
        
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

//MARK: -
//MARK: UIKeyboard Notifications
extension RecoverViewController {
    
    @objc func keyboardWasShown(_ n: Notification) {
        
        
        guard let info = n.userInfo, let kbSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue, let curve = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            
            return
            
        }
        
        scrollViewBottomLayoutConstraint.constant = kbSize.height - 20
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16) , animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
        
                
    }
    
    @objc  func keyboardWillBeHidden(_ n: Notification) {
        
        
        guard let info = n.userInfo, let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue, let curve = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            
            return
            
            
            
        }
        
        
        self.scrollViewBottomLayoutConstraint.constant = 0
        self.view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16) , animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
        
        
        
        
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        
        view.firstResponder?.resignFirstResponder()
        
    }
        
    
}
