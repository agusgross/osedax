//
//  PurchasesViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/30/21.
//

import UIKit
import Toast
import Kingfisher

class PurchasesViewController: UIViewController {
    
    var userManager: UserManager!
    var chapterStore: ChapterStore!
    var config: Config!
    
    @IBOutlet weak var restorePurchasesButton: Button!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        
    }
    
    @IBAction func restorePurchasesButtonTapped(_ sender: Any) {
        
        fetchChapters()
        
    }
    
    private func fetchChapters(){
        
        enableUI(false)
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
        
            
            self.userManager.chapters(language: LocaleHelper.getLocale(), version: Bundle.main.infoDictionary?["CFBundleVersion"] as! String) { [weak self] chapters, error in
                
                guard let self = self else { return }
                
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
                        
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.enableUI()
                    self.view.makeToast(NSLocalizedString("purchases_restored", comment: ""))
                }
                
                
                    
                
                
                
            }
            
            
        }
        
    }
    

    private func enableUI(_ enable: Bool = true){
        
        restorePurchasesButton.isHidden = !enable
        
        if enable {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        
        
    }
 
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }


    
}
