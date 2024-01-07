//
//  ClippingsViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/28/21.
//

import UIKit

class ClippingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClippingTableViewCellDelegate  {
    
    static let gotoClippingEvent = Notification.Name("gotoClippingEvent")
    
    var chapterStore: ChapterStore!
    var userManager: UserManager!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: Label!
    
    private var clippings = [TextClipping]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        
        tableView.register(ClippingTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.insetsContentViewsToSafeArea = false
        
        
        clippings.append(contentsOf: chapterStore.getClippings())
        
        emptyStateLabel.isHidden = clippings.count > 0
        
        tableView.reloadData()
    

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ClippingTableViewCell
        
        let clipping = clippings[indexPath.row]
        
        
        cell.clippingTitleLabel.text = "\(clipping.chapter?.title.uppercased() ?? ""). \(clipping.episode?.episodeNumber ?? 0) \(clipping.episode?.title ?? "")"
        cell.clippingTextLabel.text = clipping.text
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        


        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clippings.count
    }

    func onClick(cell: ClippingTableViewCell) {
        
        
        if let indexPath = tableView.indexPath(for: cell) {
           
            let clipping = clippings[indexPath.row]
            
            if let chapter = clipping.chapter , let episode = clipping.episode {
                chapterStore.bookmark = Bookmark(chapter: chapter, episode: episode, position: clipping.position, characterCode: clipping.characterCode)
                
                
                NotificationCenter.default.post(name: Self.gotoClippingEvent, object: nil, userInfo: ["chapterId": chapter.id, "episodeId": episode.id])
                
                navigationController?.popViewController(animated: true)
            }
             
            

            

        }
    }
    
    func onDelete(cell: ClippingTableViewCell) {

        if let indexPath = tableView.indexPath(for: cell) {
           
            let clippingId = clippings[indexPath.row].id
            
            userManager.deleteTextClipping(textClippingId: clippingId) { _, _ in
                
            }
            
            clippings.remove(at: indexPath.row)
            
            tableView.reloadData()
            
            chapterStore.deleteClipping(id: clippingId)
            
            emptyStateLabel.isHidden = clippings.count > 0
            
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }


}
