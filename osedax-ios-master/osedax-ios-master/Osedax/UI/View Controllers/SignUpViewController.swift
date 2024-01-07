//
//  SignUpViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/23/21.
//

import UIKit
import Kingfisher
import SafariServices

class SignUpViewController: UIViewController, UITextViewDelegate, SFSafariViewControllerDelegate {
    
    var userManager: UserManager!
    var chapterStore: ChapterStore!
    var config: Config!
    
    var isProfile = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var supportTextView: UITextView! {
        didSet {
            
            supportTextView.text = String.init(format: NSLocalizedString("support_text", comment: ""), NSLocalizedString("contact_us", comment: ""))
            supportTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
             
            let string = NSString(string: String.init(format: NSLocalizedString("support_text", comment: ""), NSLocalizedString("contact_us", comment: "")))
            let attributtedString = NSMutableAttributedString(string: string as String)

            var linkAttributes:[NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.white,
                .link: "mailto:info@osedax.app",
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.white,
            ]
            attributtedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.length))
            attributtedString.addAttributes(linkAttributes, range: string.range(of: NSLocalizedString("contact_us", comment: "")) )

            let style = NSMutableParagraphStyle()
            style.alignment = .center

            attributtedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: string.length))

            supportTextView.attributedText = attributtedString
            supportTextView.delegate = self
            
        }
    }
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var emailAddressTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var repeatPasswordTextField: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: Button!
    @IBOutlet weak var revealPasswordButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var scrollViewBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailNotificationsSwitch: UISwitch!
    @IBOutlet weak var termsTextView: UITextView! {
        didSet {
            
            termsTextView.text = String.init(format: NSLocalizedString("by_signing_up_you_accept", comment: ""), NSLocalizedString("terms_and_conditions", comment: ""), NSLocalizedString("privacy_policy", comment: ""))
            termsTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorAccent")]
             
            let string = NSString(string: String.init(format: NSLocalizedString("by_signing_up_you_accept", comment: ""), NSLocalizedString("terms_and_conditions", comment: ""), NSLocalizedString("privacy_policy", comment: ""), NSLocalizedString("COOKIES_POLICY", comment: "")))
            let attributtedString = NSMutableAttributedString(string: string as String)
            
            attributtedString.addAttribute(.link , value: "https://\(LocaleHelper.getLocale() == "es" ? "es" : "www").osedax.app/terms-conditions", range: string.range(of: NSLocalizedString("terms_and_conditions", comment: "")) )
            attributtedString.addAttribute(.link , value: "https://\(LocaleHelper.getLocale() == "es" ? "es" : "www").osedax.app/privacy-policy", range: string.range(of: NSLocalizedString("privacy_policy", comment: "")) )
            attributtedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.length))
            
            
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            
            attributtedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: string.length))
            
            termsTextView.attributedText = attributtedString
            termsTextView.delegate = self
            
        }
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = User.currentUser {
            self.user = user
            isProfile = true
            getUser()
        }

        setupUI()
        
        
    }
    
    private func setupUI(){
        

        if isProfile {
            titleLabel.text = NSLocalizedString("edit_your_profile_details", comment: "")
            signUpButton.setTitle(NSLocalizedString("save", comment: "").uppercased(), for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification , object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)) )
        self.view.addGestureRecognizer(tapGesture)

        
    }
    
    @IBAction func revealPasswordButtonTapped(_ sender: Any) {
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        revealPasswordButton.setImage(passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "ic_eye") : #imageLiteral(resourceName: "ic_hide"), for: .normal)
        
        
    }
    

    
    private func enableUI(_ enable: Bool = true){
        
        signUpButton.isHidden = !enable

        if enable {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }

        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
            
        view?.firstResponder?.resignFirstResponder()
        
        enableUI(false)
        
        if user == nil {
            user = User()
        }
        
        user?.plainPassword = passwordTextField.text
        user?.firstName = firstNameTextField.text
        user?.email = emailAddressTextField.text
        user?.emailNotifications = emailNotificationsSwitch.isOn
        
        
        if isProfile {
            userManager.editProfile(user: user!, done: responseHandler)
        } else {
            userManager.register(user: user!, done: responseHandler)
        }
        
    
    }
    
    
    private var responseHandler: (RestResponse?, Error?) -> () {
        get {
            
            return { [weak self] response, error in
                
                
                if let error = error {
                        
                    DialogHelper.showDialog(self, title: "sign_up".localized, text: error.localizedDescription, okButton: "ok".localized) { [weak self] in
                        
                        self?.enableUI()
                        
                    }
                    
                } else if response?.ok == true {
                    
                    if self?.isProfile == true {
                        
                        self?.navigationController?.popViewController(animated: true)
                    
                    } else {
                    
//                        if self?.userManager.isUserLoggedIn() == true {
//
//                            User.currentUser = self?.user
//
//                        } else {
                            
                            self?.userManager.login(username: self?.user?.email ?? "", password: self?.user?.plainPassword ?? "", completion: { [weak self] error in
                                
                                
                                if error == nil {
                                    
                                    
                                    self?.userManager.getUser() { [weak self] user, error in
                                        
                                        
                                        User.currentUser = user
                                        
                                        self?.fetchChapters()
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                            })
                            
                                
//                        }
                    }
                        
                } else {
                    
                    
                    DialogHelper.showDialog(self, title: "sign_up".localized, text: "please_verify_the_following".localized + "\n\n\(response?.getError() ?? "")", okButton: "ok".localized) { [weak self] in
                        
                        self?.enableUI()
                        
                    }
                    
                    
                }
                    
                    
            }
                
        }
            
    }
    
    private func fetchChapters(){
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            let forceReload = self.chapterStore.shouldReset()
            
            if self.chapterStore.chapters.count == 0 || forceReload {
                
                self.userManager.chapters(language: LocaleHelper.getLocale(), version: Bundle.main.infoDictionary?["CFBundleVersion"] as! String) { chapters, error in
                    
                    if let chapters = chapters {
                        
                        chapters.forEach { [weak self] chapter  in
                            
                            guard let self = self else { return }
                            
                            KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterOneOptionA).jpg")!, completionHandler: nil)
                            KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterOneOptionB).jpg")!, completionHandler: nil)

                            
                            if chapter.numberOfCharacters > 1 {
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterTwoOptionA).jpg")!, completionHandler: nil)
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterTwoOptionB).jpg")!, completionHandler: nil)
                            }

                            if chapter.numberOfCharacters > 2 {
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterThreeOptionA).jpg")!, completionHandler: nil)
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterThreeOptionB).jpg")!, completionHandler: nil)
                            }

                            if chapter.numberOfCharacters > 3 {
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterFourOptionA).jpg")!, completionHandler: nil)
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())\(chapter.characterFourOptionB).jpg")!, completionHandler: nil)
                            }


                        }
                        
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.chapterStore.chapters = chapters
                            
                            if forceReload {
                                self.chapterStore.resetCharacterSelection()
                            }
                            
                            
                            self.gotoMain()
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
            } else {
                
                self.gotoMain()
                
            }
            
            
        }
        
    }
    
    private func gotoMain(){
        
        navigationController?.performSegue(withIdentifier: "purchase", sender: nil)
        
    }
    
    private func getUser(){
        
        firstNameTextField.text = User.currentUser?.firstName
        emailAddressTextField.text = User.currentUser?.email
        emailNotificationsSwitch.isOn = user?.emailNotifications ?? false
        
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIDeviceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()


    }



    
}

//MARK: -
//MARK: UIKeyboard Notifications
extension SignUpViewController {
    
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
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if textView == supportTextView {


          if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL)
          } else {
            UIApplication.shared.openURL(URL)
          }


        } else {

            let vc = SFSafariViewController(url: URL)
            vc.delegate = self
            self.navigationController?.present(vc, animated: true)
            

        }
        
        
        return false
        
    }

    
}



