//
//  PageViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/1/21.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIScrollViewDelegate, UIPageViewControllerDelegate {
    
    static let scrollEvent = Notification.Name("scrollEvent")
    
    var chapterStore: ChapterStore!
    
    var scrollView: UIScrollView?
    
    
    enum Step {
        case stepIntro(chapterId: Int, episodeId: Int)
        case stepCharacterSelect(chapterId: Int, episodeId: Int, characterSet: Int)
        case stepRead(chapterId: Int, episodeId: Int)
        case stepPurchase(chapterId: Int, episodeId: Int)
    }
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        scrollView = view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        scrollView?.delegate = self
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.onReloadBookmarkNotification(notification:)), name: MenuViewController.reloadBookmarkEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onSelectCharactersNotification(notification:)), name: RightMenuViewController.selectCharactersEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onGoToClippingNotification(notification:)), name: ClippingsViewController.gotoClippingEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onReloadSlideNotification(notification:)), name: ReadViewController.reloadSlideEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onForwardSlideNotification(notification:)), name: ReadViewController.forwardSlideEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onDisplayAdNotification(notification:)), name: ReadViewController.displayAdEvent, object: nil)


    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    private func setupUI(){
        setFirstPage()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? SlideableViewController, let slide = vc.slide, let newSlide = slideAfter(slide: slide) else {
            
            
                return nil
            
        }
        
        return viewControllerForSlide(slide: newSlide)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    private func setFirstPage(slide: Step? = nil){
        
        if let firstSlide = slideAfter(slide: slide) {
            
            setViewControllers([viewControllerForSlide(slide: firstSlide)], direction: .forward, animated: false, completion: nil)
//            shouldLoadAd()
        }
        
    }
    
    private func viewControllerForSlide(slide: Step) -> UIViewController {
        
        let vc: SlideableViewController
        switch slide {
        case .stepIntro:
            vc = (storyboard?.instantiateViewController(withIdentifier: "intro")) as! SlideableViewController
        case .stepRead:
            vc = (storyboard?.instantiateViewController(withIdentifier: "read")) as! SlideableViewController
        case .stepCharacterSelect:
            vc = (storyboard?.instantiateViewController(withIdentifier: "characters")) as! SlideableViewController
        case .stepPurchase:
            vc = (storyboard?.instantiateViewController(withIdentifier: "purchaseChapter")) as! SlideableViewController

        }
        
        vc.slide = slide
        
        return vc
        
    }
    
    private func slideAfter(slide: Step?) -> Step?{

        switch slide {
        case nil:
            return slideFromBookmark() ?? stepForCharactersOrRead(slide)
        case .stepCharacterSelect:
            return stepForCharactersOrRead(slide)
        case .stepIntro(let chapterId, let episodeId):
            return .stepRead(chapterId: chapterId,episodeId: episodeId)
        case .stepRead(let chapterId, let episodeId):
            return chapterStore.chapter(chapterId).purchased ? stepForCharactersOrReadOrEnd(slide!) : ( chaptersLeft(chapterId, episodeId) ?  .stepPurchase(chapterId: chapterId, episodeId: episodeId) : nil )
        case .stepPurchase:
            return stepForCharactersOrReadOrEnd(slide!)
        }

    }
    
    private func stepForCharactersOrRead(_ step: Step?) -> Step {

        if stillHasCharactersToSelect(step)  {

            if let aNextCharacterSet = nextCharacterSet(step) {

                return .stepCharacterSelect(chapterId: chapterFromSlide(step),episodeId: episodeFromSlide(step), characterSet: aNextCharacterSet)
            } else {
                fatalError("Illegal argument")
            }
        } else{
            

            if case let .stepCharacterSelect(chapterId, episodeId, _) = step,  chapterId == chapterStore.bookmark?.chapter?.id, episodeId == chapterStore.bookmark?.episode?.id {
                return .stepRead(chapterId: chapterId, episodeId: episodeId)
            } else {
                return .stepIntro(chapterId: chapterFromSlide(step),episodeId: episodeFromSlide(step))

            }

        }
    }

    private func stepForCharactersOrReadOrEnd(_ slide: Step) -> Step? {

        
        if case let .stepRead(chapterId, episodeId) = slide, chaptersLeft(chapterId, episodeId)  {
            return stepForCharactersOrRead(slide)
        } else if case let .stepPurchase(chapterId, episodeId) = slide, chaptersLeft(chapterId, episodeId)  {
            return stepForCharactersOrRead(slide)
        } else {
            return nil
        }
    }

    private func stillHasCharactersToSelect(_ step: Step?) -> Bool{

        return nextCharacterSet(step) != nil


    }

    private func nextCharacterSet(_ step: Step?) -> Int? {
        switch step {
        case .stepCharacterSelect(let chapterId, let episodeId, let characterSet):
            return chapterStore.nextCharacterSet(currentCharacterSet: characterSet, chapterId: chapterId, episodeId: episodeId)
        case nil:
            return chapterStore.nextCharacterSet(currentCharacterSet: -1, chapterId: nil, episodeId: nil)
        default:
            return chapterStore.nextCharacterSet(currentCharacterSet: -1, chapterId: chapterFromSlide(step), episodeId: episodeFromSlide(step))
        }


    }
    
    private func chaptersLeft(_ chapterId: Int, _ episodeId: Int) -> Bool{

//        return chapterStore.chapter(chapterId).purchased && chapterStore.episodeAfter(chapterId, episodeId) != nil
        return chapterStore.episodeAfter(chapterId, episodeId) != nil

    }
    
    private func chapterFromSlide(_ slide: Step?) -> Int{

        switch slide {
            case nil:
                return chapterStore.firstChapterId()
            case .stepCharacterSelect(let chapterId, _, _):
                return chapterId
            case .stepRead(let chapterId, let episodeId):
                return chapterStore.chapter(chapterId).purchased ?  chapterStore.chapterAfter(chapterId, episodeId)! :  chapterId
            case .stepIntro(let chapterId, _):
                return chapterId
            case .stepPurchase(let chapterId, let episodeId):
                return chapterStore.chapterAfter(chapterId, episodeId)!

        }

    }
    
    private func episodeFromSlide(_ slide: Step?) -> Int{

        switch slide {
            case nil:
                if let episodeId =  chapterStore.firstEpisodeId() {
                    return episodeId
                } else {
                    fatalError("Invalid argument")
                }
            case .stepCharacterSelect(_, let episodeId, _):
                return episodeId
            case .stepRead(let chapterId, let episodeId):
                return chapterStore.chapter(chapterId).purchased ?  chapterStore.episodeAfter(chapterId, episodeId)! :  episodeId
            case .stepIntro(_, let episodeId):
                return episodeId
            case .stepPurchase(let chapterId, let episodeId):
                return chapterStore.episodeAfter(chapterId, episodeId)!

        }

    }

    private func slideFromBookmark() -> Step? {

        if let bookmark = chapterStore.bookmark {
            let chapterId = bookmark.chapter?.id
            let episodeId = bookmark.episode?.id
            if let chapterId = chapterId, let episodeId = episodeId {
                return .stepRead(chapterId: chapterId, episodeId: episodeId)
            }
        }

        return  nil

    }

    @objc private func onSelectCharactersNotification(notification: Notification){
        
        let info = notification.userInfo

        let slide = Step.stepCharacterSelect(chapterId: info?["chapterId"] as! Int, episodeId: info?["episodeId"] as! Int, characterSet: 0)

        setViewControllers([viewControllerForSlide(slide: slide)], direction: .forward, animated: false, completion: nil)
//        shouldLoadAd()
//        debugPrint("GGR \(info?["chapterId"] as! Int)")
//        debugPrint("GGR \(info?["episodeId"] as! Int)")
        
    }

    @objc private func onReloadBookmarkNotification(notification: Notification){
        
        let info = notification.userInfo

        let slide = stepForCharactersOrRead(Step.stepIntro(chapterId: info?["chapterId"] as! Int, episodeId: info?["episodeId"] as! Int))
        
        setViewControllers([viewControllerForSlide(slide: slide)], direction: .forward, animated: false, completion: nil)
//        shouldLoadAd()
//        debugPrint("GGR \(info?["chapterId"] as! Int)")
//        debugPrint("GGR \(info?["episodeId"] as! Int)")
        
    }
    

    @objc private func onGoToClippingNotification(notification: Notification){
        
        let info = notification.userInfo

        let slide = Step.stepRead(chapterId: info?["chapterId"] as! Int, episodeId: info?["episodeId"] as! Int)
        
        setViewControllers([viewControllerForSlide(slide: slide)], direction: .forward, animated: false, completion: nil)
                
//        debugPrint("GGR \(info?["chapterId"] as! Int)")
//        debugPrint("GGR \(info?["episodeId"] as! Int)")
        
    }
    
    @objc private func onReloadSlideNotification(notification: Notification){
        
        
                    
        setFirstPage()
        
    }

    @objc private func onForwardSlideNotification(notification: Notification){
        
        guard let vc = viewControllers?.first as? SlideableViewController else { return }
        
        setFirstPage(slide: vc.slide)
        
    }

    @objc private func onDisplayAdNotification(notification: Notification){
        
                    
        shouldLoadAd()
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if initialScrollViewPosition == nil {
//            initialScrollViewPosition = scrollView.contentOffset.y
//        } else {
//
//        }
//
//        debugPrint("GGR - \(scrollView.contentOffset.y + (initialScrollViewPosition ?? 0))")
        
        if let vc = viewControllers?.first as? IntroViewController {
            vc.updateParallax(update: scrollView.contentOffset.y)
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
//            shouldLoadAd()
        }
    }
    
    private func shouldLoadAd(){

        if let vc = viewControllers?.first as? SlideableViewController, let step = vc.slide {
            
            switch step {
            case .stepCharacterSelect(let chapterId, _, let characterSet):
                let chapter = chapterStore.chapter(chapterId)
                if !chapter.purchased && characterSet == 0 && chapterStore.characterSelection(name: chapter.characterOneName) == nil{
                    requestIDFA()
                }
            case .stepIntro(let chapterId, _):
                let chapter = chapterStore.chapter(chapterId)
                if !chapter.purchased{
                    requestIDFA()
                }
            case .stepRead(let chapterId, _):
                let chapter = chapterStore.chapter(chapterId)
                if !chapter.purchased{
                    requestIDFA()
                }
            case .stepPurchase:
                print("")
            }
            
            

        }
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { [weak self] status in
            // Tracking authorization completed. Start loading ads here.
            self?.loadAd()
          })
        } else {
            loadAd()
        }
    }

    private func loadAd(){
                
        /* interstitial ad */
        let request = GADRequest()
//        GADAdLoader(adUnitID: "", rootViewController: self, adTypes: [.native], options: [.preferredImageOrientation: GADNativeAdImageAdLoaderOptions.preferredImageOrientation]).load(request)

        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-4084713068647778/7369307957", request: request, completionHandler: { [self] ad, _ in
            ad?.present(fromRootViewController: self)
            
            
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIDeviceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()


    }

    override var shouldAutorotate: Bool {
        return true
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    
}

protocol SlideableViewController where Self: UIViewController {
    var slide: PageViewController.Step? { get set }
}
