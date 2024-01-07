//
//  PurchaseChapterViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 11/21/21.
//
import UIKit
import StoreKit
import Kingfisher

class PurchaseChapterViewController: UIViewController, SlideableViewController {
    
    var config: Config!
    var chapterStore: ChapterStore!
    var userManager: UserManager!
    var chapter: Chapter! = nil
    var episode: Episode! = nil
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var step: PageViewController.Step?
    var slide: PageViewController.Step? {
        get {
            return step
        }
        set {
            step = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        /* Payment */
        SKPaymentQueue.default().add(self)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SKPaymentQueue.default().remove(self)
    }

    private func setupUI(){
        
        guard case let .stepPurchase(chapterId, episodeId) = step else { return }
        
        chapter = chapterStore.chapter(chapterId)
        episode = chapterStore.episode(chapterId, episodeId)

        let image = "purchase_\(episode.id)"

        imageView.kf.setImage(with: URL(string: "\(config.imagesUrl())/\(image).jpg")!)
        
    
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    
        
        

    }
    
    private func enableUI(_ enable: Bool = true){
        
        buttonsStackView.isHidden = !enable
        
        if enable {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
        
        
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        
        NotificationCenter.default.post(name: ReadViewController.forwardSlideEvent, object: nil)
    }
    
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        
        enableUI(false)
        
        getProducts()
    }
    
    func getProducts() {
        
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set(["CHAPTER"]))
            
            request.delegate = self
            
            request.start()
        }
     
    }

    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
     
        
    }
    
}

extension PurchaseChapterViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        
        debugPrint("")
    }


}

extension PurchaseChapterViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        
        guard case .stepPurchase(let chapterId, _) = step else { return }
        
        transactions.forEach { transaction in
            
            switch transaction.transactionState {
            
            case .purchasing, .deferred:
                debugPrint("GGR", "PURCHASING OR DEFERRED")
                break
            case .purchased, .restored:
                debugPrint("GGR", "PURCHASED OR RESTORED")
                userManager.purchase(language: LocaleHelper.getLocale(), sku: chapterStore.chapter(chapterId).sku) { [weak self] chapter, error in
                    
                    guard let self = self else { return }
                    
                    
                    if let chapter = chapter {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        
                            
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
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.chapterStore.addChapter(chapter: chapter)
                            NotificationCenter.default.post(name: ReadViewController.reloadSlideEvent, object: nil)
                            
                        }
                    }
                    
                }
            case .failed:
                debugPrint("GGR", "FAILED")
                enableUI()
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }

}
