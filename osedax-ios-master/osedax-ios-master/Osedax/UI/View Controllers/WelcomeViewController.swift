//
//  WelcomeViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/14/21.
//

import UIKit
import Kingfisher

class WelcomeViewController: UIViewController {
    
    var userManager: UserManager!
    var chapterStore: ChapterStore!
    var config: Config!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signUpButton: Button!
    @IBOutlet weak var loginButton: Button!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        
        checkUserLoggedIn()
    }
    
    private func checkUserLoggedIn(){
//        userManager.removeAccessToken()
        if userManager.isUserLoggedIn() {
            
            userManager.getUser { [weak self] user, error  in
                
                if let user = user {
                    User.currentUser = user
                    self?.fetchChapters()
                } else {    
                    self?.displayLoginOptions()
                }
            }
            
            
        } else {
            
            displayLoginOptions()
            
        }
        
        
        
    }
    
    private func gotoHome() {
        
        navigationController?.performSegue(withIdentifier: "main", sender: nil)
        
    }
    
    private func displayLoginOptions(){
        
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.titleLabel.isHidden = false
            self?.loginButton.isHidden = false
            self?.signUpButton.isHidden = false
        }
    }
    
    private func fetchChapters(){
        
        let forceReload = chapterStore.shouldReset()
        
        if chapterStore?.chapters.count == 0 || forceReload {  /* if there are no chapters locally, fetch from server */
            
            userManager.chapters(language: LocaleHelper.getLocale(), version: Bundle.main.infoDictionary?["CFBundleVersion"] as! String, done: { [weak self] chapters, _ in
                    
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
                    
                    self?.chapterStore.chapters = chapters
                    if forceReload {
                        self?.chapterStore.resetCharacterSelection()
                    }
                }
                
                self?.gotoHome()
                
                
            })
            
            
        } else {
            
            getNewChapters()
        }
        
        
    }
    
    private func getNewChapters(){
        
        let firstChapterReloaded = UserDefaults.standard.bool(forKey: "firstChapterReloaded")
        
        guard let lastChapterId = !firstChapterReloaded ? 0 : chapterStore.chapters.last?.id else {
            gotoHome()
            return
        }
        
        
        
        userManager.chaptersAfter(language: LocaleHelper.getLocale(), chapterId: lastChapterId, version: Bundle.main.infoDictionary?["CFBundleVersion"] as! String , done: { [weak self] chapters, _ in
                
            if let chapters = chapters {
                
                UserDefaults.standard.setValue(true, forKey: "firstChapterReloaded")
                
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
                    
                    self.chapterStore.appendNewChapter(chapter: chapter)

                }
                
                
            }
            
            self?.gotoHome()
            
            
        })
        
        
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
