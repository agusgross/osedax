//
//  EpisodeTitleTableViewCell.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/27/21.
//

import UIKit

class EpisodeTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeNumberLabel: Label!
    @IBOutlet weak var episodeTitleLabel: Label!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
        
    }
    
    func markAsSelected(selected: Bool = true) {
        
        let color = selected ? UIColor(named: "ColorAccent") : .white
        episodeNumberLabel.textColor = color
        episodeTitleLabel.textColor = color

    }
    
    
    private func setupUI(){
        
        selectionStyle = .none
        
        backgroundColor = .clear
        backgroundView = UIView()
        
        
    }
}
