//
//  PurchaseViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 11/13/21.
//

import UIKit
import Kingfisher
import StoreKit

class PurchaseViewController: UIViewController {

    var userManager: UserManager!
    var chapterStore: ChapterStore!
    var config: Config!

    @IBOutlet weak var purchaseButton: Button!
    @IBOutlet weak var purchasingActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }

    
    @IBAction func skipButtonTapped(_ sender: Any) {
        
        navigationController?.performSegue(withIdentifier: "main", sender: nil)
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        
        purchasingActivityIndicatorView.startAnimating()
        purchaseButton.isHidden = true
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

extension PurchaseViewController: SKProductsRequestDelegate {
    
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

extension PurchaseViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            
            switch transaction.transactionState {
            
            case .purchasing, .deferred:
                debugPrint("GGR", "PURCHASING OR DEFERRED")
                break
            case .purchased, .restored:
                debugPrint("GGR", "PURCHASED OR RESTORED")
                userManager.purchase(language: LocaleHelper.getLocale(), sku: "chapter01") { [weak self] chapter, error in
                    
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
                            self.navigationController?.performSegue(withIdentifier: "main", sender: nil)
                            
                        }
                    }
                    
                }
            case .failed:
                debugPrint("GGR", "FAILED")
                purchasingActivityIndicatorView.stopAnimating()
                purchaseButton.isHidden = false
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }

}
