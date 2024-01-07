//
//  LoginViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/17/21.
//

import UIKit
import Kingfisher

class LoginViewController: UIViewController {
    
    var userManager: UserManager!
    var chapterStore: ChapterStore!
    var config: Config!
    
    @IBOutlet weak var emailAddressTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var recoverPasswordButton: ButtonSmall!
    @IBOutlet weak var revealPasswordButton: UIButton!
    @IBOutlet weak var loginButton: Button!
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
    
    @IBAction func revealPasswordButtonTapped(_ sender: Any) {
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        revealPasswordButton.setImage(passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "ic_eye") : #imageLiteral(resourceName: "ic_hide"), for: .normal)
        
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailAddressTextField.text, let password = passwordTextField.text else { return }
        
        view?.firstResponder?.resignFirstResponder()
        
        enableUI(false)
        
        userManager.login(username: email, password: password) { [weak self] error in
        
            if error == nil {

                let _ = self?.userManager?.getUser(done: { [weak self] user, error in
                    
                    DispatchQueue.main.async {

                        User.currentUser = user
                        self?.fetchChapters()
                                                    
                    }
                    

                    
                    
                })

            } else {
                
                DispatchQueue.main.async {
                    
                    DialogHelper.showDialog(self, title: "login".localized, text: "login_error".localized, okButton: "OK")
                    self?.enableUI()
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    private func enableUI(_ enable: Bool = true){
        
        recoverPasswordButton.isEnabled = enable
        loginButton.isHidden = !enable
        
        if enable {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        
        
    }
    
    private func fetchChapters(){
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            let forceReload = true //self.chapterStore.shouldReset()
            
            if self.chapterStore.chapters.count == 0 || forceReload {
                
                self.userManager.chapters(language: LocaleHelper.getLocale(), version: Bundle.main.infoDictionary?["CFBundleVersion"] as! String) { chapters, error in
                    
                    if let chapters = chapters {
                        
                        chapters.forEach { [weak self] chapter  in
                            
                            guard let self = self else { return }
                            
                            KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterOneOptionA).jpg")!, completionHandler: nil)
                            KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterOneOptionB).jpg")!, completionHandler: nil)

                            
                            if chapter.numberOfCharacters > 1 {
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterTwoOptionA).jpg")!, completionHandler: nil)
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterTwoOptionB).jpg")!, completionHandler: nil)
                            }

                            if chapter.numberOfCharacters > 2 {
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterThreeOptionA).jpg")!, completionHandler: nil)
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterThreeOptionB).jpg")!, completionHandler: nil)
                            }

                            if chapter.numberOfCharacters > 3 {
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterFourOptionA).jpg")!, completionHandler: nil)
                                KingfisherManager.shared.retrieveImage(with: URL(string: "\(self.config.imagesUrl())/\(chapter.characterFourOptionB).jpg")!, completionHandler: nil)
                            }


                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.chapterStore.chapters = chapters
                            
                            if forceReload {
                                self.chapterStore.resetCharacterSelection()
                            }
                            
                            self.userManager.initialize { initResponse, error in
                                
                                
                                DispatchQueue.main.async { [weak self] in
                                    
                                    guard let self = self else { return }
                                    
                                    initResponse?.bookmarks.forEach({ bookmark in
                                        let chapterId = bookmark.chapter?.id
                                        let episodeId = bookmark.episode?.id
                                        
                                        if let chapterId = chapterId, let episodeId = episodeId {
                                            bookmark.chapter = self.chapterStore.chapter(chapterId)
                                            bookmark.episode = self.chapterStore.episode(chapterId, episodeId)
                                        }
                                        
                                        self.chapterStore.bookmark = bookmark
                                        
                                    })
                                    
                                    initResponse?.textClippings.forEach({ textClipping in
                                        let chapterId = textClipping.chapter?.id
                                        let episodeId = textClipping.episode?.id
                                        
                                        if let chapterId = chapterId, let episodeId = episodeId {
                                            textClipping.chapter = self.chapterStore.chapter(chapterId)
                                            textClipping.episode = self.chapterStore.episode(chapterId, episodeId)
                                        }
                                        
                                        self.chapterStore.saveTextClipping(textClipping: textClipping)
                                        
                                    })
                                    
                                    initResponse?.characterSelects.forEach({ characterSelect in
                                        
                                        self.chapterStore.saveCharacterSelection(characterSelect: characterSelect)
                                        
                                    })
                                    
                                    self.gotoMain()
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
            } else {
                
                self.gotoMain()
                
            }
            
            
        }
        
    }
    
    private func gotoMain(){
        
        navigationController?.performSegue(withIdentifier: "main", sender: nil)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }


    
}

//MARK: -
//MARK: UIKeyboard Notifications
extension LoginViewController {
    
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
