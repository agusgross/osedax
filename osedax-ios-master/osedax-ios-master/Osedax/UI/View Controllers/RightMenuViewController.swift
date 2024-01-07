//
//  RightMenuViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/23/21.
//

import UIKit

class RightMenuViewController: UIViewController {
    
    var chapterStore: ChapterStore!
    
    static let profileNavigationEvent = Notification.Name("profileNavigationEvent")
    static let clippingsNavigationEvent = Notification.Name("clippingsNavigationEvent")
    static let purchasesNavigationEvent = Notification.Name("purchasesNavigationEvent")
    static let openRightMenuEvent = Notification.Name("openRightMenu")
    static let closeRightMenuEvent = Notification.Name("closeRightMenuEvent")
    static let selectCharactersEvent = Notification.Name("selectCharactersEvent")
    
    @IBOutlet weak var accountButton: ButtonMenu! {
        didSet {
            let attributedString = NSMutableAttributedString(string: accountButton.titleLabel?.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 6, range: NSRange(location: 0, length: attributedString.length))
            accountButton.setAttributedTitle(attributedString, for: .normal)

        }
    }

    @IBOutlet weak var charactersButton: ButtonMenu! {
        didSet {
            let attributedString = NSMutableAttributedString(string: charactersButton.titleLabel?.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 6, range: NSRange(location: 0, length: attributedString.length))
            charactersButton.setAttributedTitle(attributedString, for: .normal)

        }
    }

    @IBOutlet weak var purchasesButton: ButtonMenu! {
        didSet {
            let attributedString = NSMutableAttributedString(string: purchasesButton.titleLabel?.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 6, range: NSRange(location: 0, length: attributedString.length))
            purchasesButton.setAttributedTitle(attributedString, for: .normal)

        }
    }

    @IBOutlet weak var clippingsButton: ButtonMenu! {
        didSet {
            let attributedString = NSMutableAttributedString(string: clippingsButton.titleLabel?.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 6, range: NSRange(location: 0, length: attributedString.length))
            clippingsButton.setAttributedTitle(attributedString, for: .normal)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Self.openRightMenuEvent, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: Self.closeRightMenuEvent, object: nil)
    }
    
    @IBAction func charactersButtonTapped(_ sender: Any) {
        
        
        guard let chapter = chapterStore.bookmark?.chapter, let episode = chapterStore.bookmark?.episode else {
            return
        }

        if  !chapter.characterOneName.isEmpty && episode.isFirstCharacterPresent {
            chapterStore.removeCharacterSelection(name: chapter.characterOneName)
        }

        if !chapter.characterTwoName.isEmpty && episode.isSecondCharacterPresent  {
            chapterStore.removeCharacterSelection(name: chapter.characterTwoName)
        }

        if !chapter.characterThreeName.isEmpty && episode.isThirdCharacterPresent {
            chapterStore.removeCharacterSelection(name: chapter.characterThreeName)
        }

        if !chapter.characterFourName.isEmpty && episode.isFourthCharacterPresent {
            chapterStore.removeCharacterSelection(name: chapter.characterFourName)
        }

        if !chapter.characterFiveName.isEmpty && episode.isFifthCharacterPresent {
            chapterStore.removeCharacterSelection(name: chapter.characterFiveName)
        }
        
        if !chapter.characterSixName.isEmpty && episode.isSixthCharacterPresent {
            chapterStore.removeCharacterSelection(name: chapter.characterSixName)
        }

        if !chapter.characterSevenName.isEmpty && episode.isSeventhCharacterPresent {
            chapterStore.removeCharacterSelection(name: chapter.characterSevenName)
        }


        NotificationCenter.default.post(name: MenuViewController.reloadBookmarkEvent, object: self, userInfo: ["chapterId": chapter.id, "episodeId": episode.id])
        
        dismiss(animated: true)


        
    }
    @IBAction func accountButtonTapped(_ sender: Any) {
        
        dismiss(animated: true) { [weak self ] in
            
            guard let self = self else { return }
            NotificationCenter.default.post(name: Self.profileNavigationEvent, object: self)
        }
        
        
        
        
        
    }
    @IBAction func clippingsButtonTapped(_ sender: Any) {
        
        dismiss(animated: true) { [weak self ] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: Self.clippingsNavigationEvent, object: self)
        }
        
        

    }
    @IBAction func purchasesButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: { [weak self ] in
            guard let self = self else { return }
            NotificationCenter.default.post(name: Self.purchasesNavigationEvent, object: self)
        })
        
        

    }
        
}
