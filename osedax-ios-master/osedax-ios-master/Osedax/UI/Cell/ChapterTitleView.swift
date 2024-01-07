//
//  ChapterTitleButton.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/27/21.
//

import UIKit


class ChapterTitleView: UIView, XibLoadable {

    @IBInspectable
    var letterSpacing: Double = 0
    
    weak var delegate: ChapterTitleViewDelegate?

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var closeMenuImageView: UIImageView!
    @IBOutlet weak var borderBottomView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        
        
    }

    func setTitle(_ title: String?) {
        button.setTitle(title, for: .normal)
        if let labelText = button.titleLabel?.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
            button.setAttributedTitle(attributedString, for: .normal)
        }

    }
    
    @IBAction func didTapButton(_ sender: Any) {
    
        delegate?.didTap(view: self)
        
    }
    
    private func setupUI(){
        

        
        
        
    }
    
    func setOpen(open: Bool = true){
        
        
        if open {
            closeMenuImageView.image = #imageLiteral(resourceName: "ic_open_menu_light")
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            borderBottomView.isHidden = false
        } else {
            closeMenuImageView.image = #imageLiteral(resourceName: "ic_close_menu")
            button.backgroundColor = UIColor(named: "ColorAccent")
            button.setTitleColor(.black, for: .normal)
            borderBottomView.isHidden = true
            
        }
        
    }




}

protocol ChapterTitleViewDelegate: class {
    func didTap(view: ChapterTitleView)
}
