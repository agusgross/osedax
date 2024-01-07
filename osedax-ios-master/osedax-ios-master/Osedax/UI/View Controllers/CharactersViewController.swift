//
//  CharactersViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/3/21.
//

import UIKit

class CharactersViewController: UIViewController, SlideableViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var chapterStore: ChapterStore!
    var userManager: UserManager!
    var characters: [String] = []
    var chapter: Chapter! = nil
    var episode: Episode! = nil

    
    @IBOutlet weak var characterLabel: UILabel!
    
    @IBOutlet weak var previousCharacterButton: Button! {
        didSet {
            previousCharacterButton.titleLabel?.lineBreakMode = .byWordWrapping
            previousCharacterButton.titleLabel?.textAlignment = .center
            previousCharacterButton.setTitle(previousCharacterButton.titleLabel?.text?.capitalized, for: .normal)
        }
    }

    @IBOutlet weak var selectCharacterButton: Button! {
        didSet {
            selectCharacterButton.titleLabel?.lineBreakMode = .byWordWrapping
            selectCharacterButton.titleLabel?.textAlignment = .center
            selectCharacterButton.setTitle(selectCharacterButton.titleLabel?.text?.capitalized, for: .normal)
            
            selectCharacterButton.setTintColorForImage(.gray)
        }
    }

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
    
    private func setupUI(){
        
        guard case let .stepCharacterSelect(chapterId,episodeId,characterSet) = step  else { return }
        
        
        chapter = chapterStore.chapter(chapterId)
        episode = chapterStore.episode(chapterId, episodeId)
        
        let characters1 = [chapter.characterOneOptionA, chapter.characterOneOptionB]
        let characters2 = [chapter.characterTwoOptionA, chapter.characterTwoOptionB]
        let characters3 = [chapter.characterThreeOptionA, chapter.characterThreeOptionB]
        let characters4 = [chapter.characterFourOptionA, chapter.characterFourOptionB]
        let characters5 = [chapter.characterFiveOptionA, chapter.characterFiveOptionB]
        let characters6 = [chapter.characterSixOptionA, chapter.characterSixOptionB]
        let characters7 = [chapter.characterSevenOptionA, chapter.characterSevenOptionB]
        
        switch characterSet {
        case 6:
            characters = characters7
            characterLabel.text = chapter.characterSevenName
        case 5:
            characters = characters6
            characterLabel.text = chapter.characterSixName
        case 4:
            characters = characters5
            characterLabel.text = chapter.characterFiveName
        case 3:
            characters = characters4
            characterLabel.text = chapter.characterFourName
        case 2:
            characters = characters3
            characterLabel.text = chapter.characterThreeName
        case 1:
            characters = characters2
            characterLabel.text = chapter.characterTwoName
        default:
            characters = characters1
            characterLabel.text = chapter.characterOneName
        }
        
        previousCharacterButton.isHidden = characterSet == 0
        

        currentCharacterSelect = chapterStore.characterSelection(name: characterLabel.text ?? "")
        
        if currentCharacterSelect == nil {
            currentCharacterSelect = CharacterSelect(name: characterLabel.text ?? "", option: 0)
            characterSelect = currentCharacterSelect
            saveCharacterSelect(characterSelect: characterSelect!)
            chapterStore.saveCharacterSelection(characterSelect: characterSelect!)
            selectCharacterButton.setTintColorForImage(.black)
        }
                
        setFirstPage()
            

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if chapterStore.bookmark == nil {
            chapterStore.bookmark = Bookmark(chapter: chapter, episode: episode)
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.arrowDownView.startAnimation()
        }

        /* bookmark */
//        chapterStore.bookmark = Bookmark(chapter: chapter, episode: episode)


    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "character") as? CharacterViewController
        
        if let vc = viewController as? CharacterViewController {
            
            
            var idx = vc.position + 1
            
            if idx >= characters.count {
                idx = 0
            }
            
            
            
            vc2?.position = idx
            vc2?.character = characters[idx]
            
        }
        
        return vc2
        
        
        
    }
        
    var currentCharacterSelect: CharacterSelect?
    var characterSelect: CharacterSelect?
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
        
            let vc = pageViewController.viewControllers?.first as! CharacterViewController

            characterSelect = CharacterSelect(name: characterLabel.text ?? "", option: vc.position)
            
//            let characterSelect = CharacterSelect(name: characterLabel.text ?? "", option: vc.position)
//            saveCharacterSelect(characterSelect: characterSelect)
//            chapterStore.saveCharacterSelection(characterSelect: characterSelect)
              
            selectCharacterButton.setTintColorForImage(currentCharacterSelect?.option == characterSelect?.option ? .black : .gray)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let vc2 = storyboard?.instantiateViewController(withIdentifier: "character") as? CharacterViewController
        
        if let vc = viewController as? CharacterViewController {
            
            
            var idx = vc.position - 1
            
            if idx < 0 {
                idx = characters.count - 1
            }

            vc2?.position = idx
            vc2?.character = characters[idx]
            
        }
        
        return vc2
    }
    
    private func setFirstPage(){
        
        let vc =  storyboard?.instantiateViewController(withIdentifier: "character") as! CharacterViewController
        vc.position = 0
        vc.character = characters[0]
        
        (children.first as! CharacterSelectViewController).setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        
        
    }
    
    private func saveCharacterSelect(characterSelect: CharacterSelect){
        
        userManager.characterSelect(characterSelect: characterSelect) { _, _ in
            
        }
        
    }

    @IBAction func leftButtonTapped(_ sender: Any) {
        
        
        let characterSelectViewController = children.first as! CharacterSelectViewController
        guard let vc = characterSelectViewController.viewControllers?.first as? CharacterViewController else { return }
        
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "character") as! CharacterViewController
        
        var idx = vc.position - 1
        
        if idx < 0 {
            idx = characters.count - 1
        }

        vc2.position = idx
        vc2.character = characters[idx]
        
        characterSelect = CharacterSelect(name: characterLabel.text ?? "", option: idx)
//        saveCharacterSelect(characterSelect: characterSelect)
//        chapterStore.saveCharacterSelection(characterSelect: characterSelect)

        selectCharacterButton.setTintColorForImage(currentCharacterSelect?.option == characterSelect?.option ? .black : .gray)
        
        characterSelectViewController.setViewControllers([vc2], direction: .reverse, animated: true, completion: nil)
        
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        
        let characterSelectViewController = children.first as! CharacterSelectViewController
        guard let vc = characterSelectViewController.viewControllers?.first as? CharacterViewController else { return }
        
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "character") as! CharacterViewController
        
        var idx = vc.position + 1
        
        if idx >= characters.count {
            idx = 0
        }
        
        vc2.position = idx
        vc2.character = characters[idx]
        
        characterSelect = CharacterSelect(name: characterLabel.text ?? "", option: idx)
//        saveCharacterSelect(characterSelect: characterSelect)
//        chapterStore.saveCharacterSelection(characterSelect: characterSelect)
        
        selectCharacterButton.setTintColorForImage(currentCharacterSelect?.option == characterSelect?.option ? .black : .gray)
        
        characterSelectViewController.setViewControllers([vc2], direction: .forward, animated: true, completion: nil)
        
        
         
    }
    
    
    @IBAction func previousCharacterButtonTapped(_ sender: Any) {
        
        guard case let .stepCharacterSelect(chapterId,episodeId,characterSet) = step  else { return }
        
        let currentChapter = chapterStore.chapter(chapterId)
        let currentEpisode = chapterStore.episode(chapterId, episodeId)
        
        switch characterSet {
        case 3:
            chapterStore.removeCharacterSelection(name: currentChapter.characterThreeName)
            chapterStore.removeCharacterSelection(name: currentChapter.characterFourName)
        case 2:
            chapterStore.removeCharacterSelection(name: currentChapter.characterTwoName)
            chapterStore.removeCharacterSelection(name: currentChapter.characterThreeName)
        case 1:
            chapterStore.removeCharacterSelection(name: currentChapter.characterOneName)
            chapterStore.removeCharacterSelection(name: currentChapter.characterTwoName)
        default:
            debugPrint("noop")
        }
        
        NotificationCenter.default.post(name: MenuViewController.reloadBookmarkEvent, object: self, userInfo: ["chapterId": chapter.id, "episodeId": episode.id])
        

        
    }
    
    @IBAction func selectCharacterButtonTapped(_ sender: Any) {
                
        currentCharacterSelect = characterSelect
        saveCharacterSelect(characterSelect: characterSelect!)
        chapterStore.saveCharacterSelection(characterSelect: characterSelect!)
        selectCharacterButton.setTintColorForImage(.black)

    }
    
    
}
