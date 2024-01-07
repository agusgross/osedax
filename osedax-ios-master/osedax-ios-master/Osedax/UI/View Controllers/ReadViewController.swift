//
//  ReadViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/3/21.
//

import UIKit
import Toast
import Kingfisher
import StoreKit

class ReadViewController: UIViewController, SlideableViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    static let reloadSlideEvent = Notification.Name("reloadSlideEvent")
    static let forwardSlideEvent = Notification.Name("forwardSlideEvent")
    static let displayAdEvent = Notification.Name("displayAdEvent")
    
    var userManager: UserManager!
    var chapterStore: ChapterStore!
    var config: Config!
    var chapter: Chapter! = nil
    var episode: Episode! = nil
    var characterCode = ""
    
    private var step: PageViewController.Step?
    var slide: PageViewController.Step? {
        get {
            return step
        }
        set {
            step = newValue
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveTextButton: UIButton!
    @IBOutlet weak var arrowDownView: ArrowDownView!
    @IBOutlet weak var arrowDown2View: ArrowDownView!
    @IBOutlet weak var purchaseView: UIView!
    @IBOutlet weak var purchasingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var purchaseButton: Button!
    @IBOutlet weak var removeAdsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        guard case let .stepRead(chapterId, episodeId) = step else { return }
        
        chapter = chapterStore.chapter(chapterId)
        episode = chapterStore.episode(chapterId, episodeId)


        characterCode = {
            
            if let bookmark = chapterStore.bookmark, !bookmark.characterCode.isEmpty {
                return bookmark.characterCode
            }
            
            let numberOfCharacters = chapter.numberOfCharacters
            
            var arr = [Int]()

            if  numberOfCharacters >= 1 && episode.isFirstCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterOneName)?.option ?? 0)
            }
            if numberOfCharacters >= 2 && episode.isSecondCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterTwoName)?.option ?? 0)
            }
            if numberOfCharacters >= 3 && episode.isThirdCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterThreeName)?.option ?? 0)
            }
            if numberOfCharacters >= 4 && episode.isFourthCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterFourName)?.option ?? 0)
            }
            if numberOfCharacters >= 5 && episode.isFifthCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterFiveName)?.option ?? 0)
            }
            if numberOfCharacters >= 6 && episode.isSixthCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterSixName)?.option ?? 0)
            }
            if numberOfCharacters >= 7 && episode.isSeventhCharacterPresent {
                arr.append(chapterStore.characterSelection(name: chapter.characterSevenName)?.option ?? 0)
            }

            return arr.map { String($0) }.joined(separator: "_")
            
        }()
        
        let text = chapterStore.getEpisodeText(chapterId: chapterId, episodeId: episodeId)
        let text2 = chapterStore.getEpisodeText2(chapterId: chapterId, episodeId: episodeId)
        
        let textCharacters =  try! JSONDecoder().decode([String:String].self, from: text.data(using: .utf8)!)
        let text2Characters = try! JSONDecoder().decode([String:String].self, from: text2.data(using: .utf8)!)
//        let firstLetter = text.removeFirst()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20

        let attributes = [NSAttributedString.Key.font: textView1.font as Any, NSAttributedString.Key.paragraphStyle: style]
        
        let attributedText1 = NSMutableAttributedString(string: textCharacters[characterCode]!, attributes: attributes)
        let attributedText2 = NSMutableAttributedString(string: text2Characters[characterCode]!, attributes: attributes)

        /* highlight saved clippings */
        let clippings = chapterStore.getClippings(episode: episode)
        clippings.filter{ $0.characterCode == characterCode }.forEach { clipping in

            
            if  clipping.paragraph == 0 {
                attributedText1.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(named: "ColorAccent") as Any, range: NSMakeRange(clipping.indexStart, clipping.indexEnd-clipping.indexStart))

            } else {
                attributedText2.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(named: "ColorAccent") as Any, range: NSMakeRange(clipping.indexStart, clipping.indexEnd-clipping.indexStart))

            }
            
        }

        
//        thumbnailImageView.image = UIImage(named: "letter_\(firstLetter.lowercased())")
        
        textView1.attributedText = attributedText1
        textView2.attributedText = attributedText2
                
        textView1.delegate = self
        textView2.delegate = self
        
        
        /* bookmark */
        
        if let bookmark = chapterStore.bookmark, bookmark.chapter?.id == chapter.id, bookmark.episode?.id == episode.id {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.scrollView.setContentOffset(CGPoint(x: 0, y: CGFloat(bookmark.position)), animated: false)
            }
            
            

        } else {
            chapterStore.bookmark = Bookmark(chapter: chapter, episode: episode)

            
            if let bookmark = chapterStore.bookmark {
                saveBookmark(bookmark: bookmark)
            }

        }

        /* Payment */
        SKPaymentQueue.default().add(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SKPaymentQueue.default().remove(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
        if chapterStore.episodeAfter(chapter.id, episode.id) == nil {
            removeAdsLabel.text = NSLocalizedString("in_order_to_read_end", comment: "")
        }
        
        /* purchase content */
//        if chapter.purchased {
//
            if chapterStore.episodeAfter(chapter.id, episode.id) != nil {
                
                arrowDownView.isHidden = false
                arrowDownView.startAnimation()
                
            }
//        } else {
//
//            purchaseView.isHidden = false
//            arrowDownView.isHidden = true
            
//            if chapterStore.episodeAfter(chapter.id, episode.id) != nil {
//                arrowDown2View.isHidden = false
//                arrowDown2View.startAnimation()
//            }
//        }
        
    }
    
    
    var selectedTextView: UITextView?
    func textViewDidChangeSelection(_ textView: UITextView) {
        
//        textView.selectedTextRange?.start
//        textView.selectedTextRange?.end
        
        if let range = textView.selectedTextRange, range.start != range.end {
            selectedTextView = textView
            saveTextButton.isHidden = false
        } else {
            selectedTextView = nil
            saveTextButton.isHidden = true
        }
                
        
    }
    
    @IBAction func saveTextButtonTapped(_ sender: Any) {
        
        defer {
            
            selectedTextView = nil
            saveTextButton.isHidden = true
            
            textView1.selectedTextRange = nil
            textView2.selectedTextRange = nil

        }
        
        guard let attributedString = selectedTextView?.attributedText, let selectedRange = selectedTextView?.selectedTextRange, let aSelectedTextView = selectedTextView else { return }
        
        let attributedText = NSMutableAttributedString(attributedString: attributedString)
  
        let startIndex = aSelectedTextView.offset(from: aSelectedTextView.beginningOfDocument, to: selectedRange.start)
        let length = aSelectedTextView.offset(from: selectedRange.start, to: selectedRange.end)
        let range = NSMakeRange(startIndex,length)
        
        attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(named: "ColorAccent") as Any, range: range)
        
        aSelectedTextView.attributedText = attributedText
        
        let textClipping = chapterStore.saveTextClipping(text: aSelectedTextView.text(in: selectedRange) ?? "", indexStart: startIndex, indexEnd: startIndex+length, episode: episode, chapter: chapter, paragraph: aSelectedTextView == textView1 ? 0 : 1, position: Int(scrollView.contentOffset.y), characterCode: characterCode)

        if let textClipping = textClipping {
            saveTextClipping(textClipping: textClipping)
        }
        
        view.makeToast(NSLocalizedString("clipping_saved", comment: ""))

    }
    
    private func saveTextClipping(textClipping: TextClipping){
        
        
        userManager.saveTextClipping(textClipping: textClipping) { _, _ in
            
        }
        
    }

    var task: DispatchWorkItem?
    private func saveBookmark(bookmark: Bookmark){
    
        task?.cancel()
        
        task = DispatchWorkItem { [weak self] in
            if !bookmark.isInvalidated {
                self?.userManager.saveBookmark(bookmark: bookmark) { _, _ in }
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: task!)
        
    }

    
    var imageAppeared = false
    var endReached = false
    private var currentScrollPosition: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if let bookmark = chapterStore.updateBookmarkPosition(position: Int(scrollView.bounds.origin.y)) {
            saveBookmark(bookmark: bookmark)
            
        }
        
        currentScrollPosition = CGFloat(scrollView.bounds.origin.y)
        
        let diff = contentView.bounds.height - (currentScrollPosition + scrollView.bounds.height)
        
        if diff <= 60 && !endReached{
            endReached = true
            NotificationCenter.default.post(name: Self.displayAdEvent, object: nil)
        }
        
        if scrollView.bounds.origin.y + scrollView.bounds.height > imageView.frame.origin.y && !imageAppeared {

            imageAppeared = true
            
            NotificationCenter.default.post(name: Self.displayAdEvent, object: nil)

            let image = "image_\(episode.id)_\(characterCode)"
            
//            imageView.kf.setImage(with: URL(string: config.imagesUrl()+"/\(image).jpg"), options: [.transition(.fade(1)), .forceTransition, .keepCurrentImageWhileLoading]) { [weak self] _ in
//
//                guard let image = self?.imageView.image, let view = self?.view else { return }
//
//                DispatchQueue.main.async {
//
//                    self?.imageView.heightAnchor.constraint(equalToConstant: view.frame.width * image.size.height / image.size.width).isActive  = true
//                }
//            }
            
//            KingfisherManager.shared.retrieveImage(with: config.imagesUrl()+"/\(image).jpg"), options: nil, progressBlock: nil) { result in
//                imageView.alpha = 0
//                switch result {
//                case .success(let value):
//
//                    DispatchQueue.main.async {
//                        imageView.image = value.image
//
//                        imageView.heightAnchor.constraint(equalToConstant: view.frame.width * image.size.height / image.size.width).isActive  = true
//
//                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
//                            imageView.alpha = 1
//                        } completion: { _ in
//                            imageView.alpha = 1
//                        }
//
//                    }
//
//
//                }
//                }
//            }
            
            KingfisherManager.shared.retrieveImage(with: URL(string: config.imagesUrl()+"/\(image).jpg")!) { [weak self] result in
                
                if let self = self, case let .success(value) = result {
                    
                    let image = value.image
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.imageView.alpha = 0
                        self.imageView.image = image
                        self.imageView.heightAnchor.constraint(equalToConstant: self.view.frame.width * image.size.height / image.size.width).isActive  = true
                        
                        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) { [weak self] in
                            self?.imageView.alpha = 1
                        } completion: { [weak self] _ in
                            self?.imageView.alpha = 1
                        }

                    }
                }
                
            }
                
            

        }
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

extension ReadViewController: SKProductsRequestDelegate {
    
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

extension ReadViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            
            switch transaction.transactionState {
            
            case .purchasing, .deferred:
                debugPrint("GGR", "PURCHASING OR DEFERRED")
                break
            case .purchased, .restored:
                debugPrint("GGR", "PURCHASED OR RESTORED")
                userManager.purchase(language: LocaleHelper.getLocale(), sku: chapter.sku) { [weak self] chapter, error in
                    
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
                        
                        DispatchQueue.main.async {
                            self.purchasingActivityIndicatorView.stopAnimating()
                            self.purchaseButton.isHidden = false
                            self.chapterStore.addChapter(chapter: chapter)
                            NotificationCenter.default.post(name: Self.reloadSlideEvent, object: nil)
                            
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
