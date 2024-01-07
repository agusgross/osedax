//
//  LeftSidebarViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/25/21.
//

import UIKit
import SideMenu

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChapterTitleViewDelegate {
    
    static let reloadBookmarkEvent = Notification.Name("reloadBookmarkEvent")
    static let openMenuEvent = Notification.Name("openMenu")
    static let closeMenuEvent = Notification.Name("closeMenu")
    
    var chapterStore: ChapterStore!
    
    @IBOutlet weak var tableView: UITableView!

    var hiddenSections = Set<Int>()
    var selectedEpisode: Episode?
    
    @IBOutlet weak var titleLabel: Label! {
        didSet {
            titleLabel.text = titleLabel.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Self.openMenuEvent, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: Self.closeMenuEvent, object: nil)
    }

    private func setupUI(){
        
        tableView.register(EpisodeTitleTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 76
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.insetsContentViewsToSafeArea = false
        
        
            
        if let bookmark = chapterStore.bookmark {
            
            selectedEpisode = bookmark.episode //.chapters.first?.episodes.first
            
            let chapters = chapterStore.chapters
        
            for (n, chapter) in chapters.enumerated() {
                if bookmark.chapter?.id != chapter.id {
                    self.hiddenSections.insert(n)
                    self.tableView.deleteRows(at: indexPathsForSection(n),
                                              with: .none)
                    
//                    view.setOpen(open: false)

                }
            }
            
            tableView.reloadData()
            
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chapterStore.chapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EpisodeTitleTableViewCell
        
        let episodes = chapterStore.chapters[indexPath.section].episodes
        
        cell.episodeNumberLabel.text = ". \(indexPath.row+1)"
        cell.episodeTitleLabel.text = episodes[indexPath.row].title.lowercased()
        
        cell.markAsSelected(selected: episodes[indexPath.row].id == selectedEpisode?.id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chapter = chapterStore.chapters[indexPath.section]
        let episode = chapter.episodes[indexPath.row]
        
//        let purchased = chapter.purchased
//
//        if !purchased {
//            episode = chapter.episodes.first!
//        }
        
        selectedEpisode = episode
        tableView.reloadData()
        
        // broadcast episode navigation
        NotificationCenter.default.post(name: MenuViewController.reloadBookmarkEvent, object: self, userInfo: ["chapterId": chapter.id, "episodeId": episode.id])
        
        dismiss(animated: true)

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        if self.hiddenSections.contains(section) {
            return 0
        }
        
        // 2
        return self.chapterStore.chapters[section].episodes.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 1
        let sectionView = ChapterTitleView.loadFromXib()
        
        // 2
        sectionView.setTitle(chapterStore.chapters[section].title.lowercased())
                
        // 4
        sectionView.tag = section
        
        sectionView.delegate = self
        
        // 5
//        sectionView.button.addTarget(self,
//                                action: #selector(self.hideSection(sender:)),
//                                for: .touchUpInside)
//
        
        if let bookmark = chapterStore.bookmark , bookmark.chapter?.id != chapterStore.chapters[section].id {
            sectionView.setOpen()
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func indexPathsForSection(_ section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let episodes = chapterStore.chapters[section].episodes
        
        for row in 0..<episodes.count {
            indexPaths.append(IndexPath(row: row,
                                        section: section))
        }
        
        return indexPaths
    }

    func didTap(view: ChapterTitleView) {

        let section = view.tag
        
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(section),
                                      with: .fade)
            view.setOpen(open: false)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(section),
                                      with: .fade)
            view.setOpen()
        }
    
    }
    
    
}
