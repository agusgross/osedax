//
//  IntroViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/3/21.
//

import UIKit

class IntroViewController: UIViewController, SlideableViewController {
    
    var config: Config!
    var chapterStore: ChapterStore!
    var chapter: Chapter! = nil
    var episode: Episode! = nil

    @IBOutlet weak var shadowView: UIView! {
        didSet {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = shadowView.bounds
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
            gradientLayer.locations = [0, 0.4, 0.6, 1]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

            shadowView.layer.insertSublayer(gradientLayer, at: 0)

        }
    }
    
    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var chapterTitleLabel: Label!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arrowDownView: ArrowDownView!
    
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
        
        chapterStore.bookmark = Bookmark(chapter: chapter, episode: episode)
    }
    
    private func setupUI(){
        
        guard case let .stepIntro(chapterId, episodeId) = step else { return }
        
        chapter = chapterStore.chapter(chapterId)
        let numberOfCharacters = chapter.numberOfCharacters
        episode = chapterStore.episode(chapterId, episodeId)
        
        chapterTitleLabel.text = "\(chapterStore.getChapterTitle(chapterId: chapterId)). \(episode.episodeNumber)".uppercased()
        titleLabel.text = chapterStore.getEpisodeTitle(chapterId: chapterId, episodeId: episodeId).uppercased()


        var image = "intro_\(episode.id)"
        if  numberOfCharacters >= 1 && episode.isFirstCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterOneName)?.option ?? 0
            image = image + "_\(option)"
        }
        if numberOfCharacters >= 2 && episode.isSecondCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterTwoName)?.option ?? 0
            image = image + "_\(option)"
        }
        if numberOfCharacters >= 3 && episode.isThirdCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterThreeName)?.option ?? 0
            image = image + "_\(option)"
        }
        if numberOfCharacters >= 4 && episode.isFourthCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterFourName)?.option ?? 0
            image = image + "_\(option)"
        }
        if numberOfCharacters >= 5 && episode.isFifthCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterFiveName)?.option ?? 0
            image = image + "_\(option)"
        }
        if numberOfCharacters >= 6 && episode.isSixthCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterSixName)?.option ?? 0
            image = image + "_\(option)"
        }
        if numberOfCharacters >= 7 && episode.isSeventhCharacterPresent {
            let option = chapterStore.characterSelection(name: chapter.characterSevenName)?.option ?? 0
            image = image + "_\(option)"
        }

        imageView.kf.setImage(with: URL(string: "\(config.imagesUrl())/\(image).jpg")!)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.onScrollEvent(notification:)), name: PageViewController.scrollEvent, object: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 1) { [weak self] in
            
            self?.chapterTitleLabel.alpha = 1
            
        } completion: { [weak self] _ in
            
            
            
        }
        
        UIView.animateKeyframes(withDuration: 2, delay: 1.4) { [weak self] in
            
            self?.titleLabel.alpha = 1
            
        } completion: { [weak self] _ in
            
            
            
        }
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 4.6) { [weak self] in
            
            self?.startLabel.alpha = 1
            
        } completion: { [weak self] _ in
            
            self?.arrowDownView.startAnimation()
            
        }
        
        /* bookmark */
//        chapterStore.bookmark = Bookmark(chapter: chapter, episode: episode)
        
        

    }
    
    @objc private func onScrollEvent(notification: Notification){
        
                

        
    }

    
    func updateParallax(update: CGFloat){
        
//        debugPrint("GGR - \(update)")
        let offset = view.convert(view.frame.origin, to: nil).y / 2
        chapterTitleLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        titleLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        startLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        arrowDownView.transform = CGAffineTransform(translationX: 0, y: offset)
        
//        debugPrint("GGR - \(view.convert(view.frame.origin, to: nil))")
        
    }
    
    
}
