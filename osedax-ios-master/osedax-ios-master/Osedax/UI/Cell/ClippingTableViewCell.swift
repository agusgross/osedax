//
//  ClippingTableViewCell.swift
//  Osedax
//
//  Created by Gustavo Rago on 4/28/21.
//

import UIKit

class ClippingTableViewCell: UITableViewCell {
    
    weak var delegate: ClippingTableViewCellDelegate?
    
    @IBOutlet weak var clippingTitleLabel: UILabel!
    @IBOutlet weak var clippingTextLabel: Label!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
        
    }
        
    private func setupUI(){
        
        selectionStyle = .none
        
        backgroundColor = .clear
        backgroundView = UIView()
    
        
    }
    
    @IBAction func gotoTextButtonTapped(_ sender: Any) {
        
        delegate?.onClick(cell: self)
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        delegate?.onDelete(cell: self)
        
    }
    
    
}

protocol ClippingTableViewCellDelegate: AnyObject {
    func onDelete(cell: ClippingTableViewCell)
    func onClick(cell: ClippingTableViewCell)
}
