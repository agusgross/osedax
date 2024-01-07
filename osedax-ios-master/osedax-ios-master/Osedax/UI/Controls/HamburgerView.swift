//
//  HamburgerView.swift
//  Osedax
//
//  Created by Gustavo Rago on 6/8/21.
//

import UIKit

class HamburgerView: UIView {
        
    let duration: CFTimeInterval = 0.3
    let trashLayer = CAShapeLayer()
    let trashLayer2 = CAShapeLayer()
    let trashLayer3 = CAShapeLayer()
        
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 24, height: 14))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addTrash()
        
    }
    
    func startAnimation(){

        openCap()

    }

    func startCloseAnimation(){

        closeCap()

    }

    private func addTrash(){
        
        let trashPath = UIBezierPath()
        let trashPath2 = UIBezierPath()
        let trashPath3 = UIBezierPath()

        let fillColor = UIColor.white

        trashPath.move(to: CGPoint(x: 0, y: 0))
        trashPath.addLine(to: CGPoint(x: 24, y: 0))
        trashPath.addLine(to: CGPoint(x: 24, y: 2))
        trashPath.addLine(to: CGPoint(x: 0, y: 2))
        trashPath.addLine(to: CGPoint(x: 0, y: 0))
        trashPath.lineWidth = 0
        trashPath.close()
        
        trashLayer.path = trashPath.cgPath
        trashLayer.position = CGPoint(x: 0, y: 7)
        trashLayer.fillColor = fillColor.cgColor
        trashLayer.strokeColor = UIColor.clear.cgColor

        trashPath2.move(to: CGPoint(x: 0, y: 0))
        trashPath2.addLine(to: CGPoint(x: 24, y: 0))
        trashPath2.addLine(to: CGPoint(x: 24, y: 2))
        trashPath2.addLine(to: CGPoint(x: 0, y: 2))
        trashPath2.addLine(to: CGPoint(x: 0, y: 0))
        trashPath2.close()

        trashLayer2.path = trashPath2.cgPath
        trashLayer2.position = CGPoint(x: 0, y: 13)
        trashLayer2.fillColor = fillColor.cgColor
        trashLayer2.strokeColor = UIColor.clear.cgColor

        trashPath3.move(to: CGPoint(x: 0, y: 2))
        trashPath3.addLine(to: CGPoint(x: 24, y: 2))
        trashPath3.addLine(to: CGPoint(x: 24, y: 0))
        trashPath3.addLine(to: CGPoint(x: 0, y: 0))
        trashPath3.addLine(to: CGPoint(x: 0, y: 2))
        trashPath3.close()

        trashLayer3.path = trashPath3.cgPath
        trashLayer3.position = CGPoint(x: 0, y: 19)
        trashLayer3.fillColor = fillColor.cgColor
        trashLayer3.strokeColor = UIColor.clear.cgColor

        self.layer.addSublayer(trashLayer)
        self.layer.addSublayer(trashLayer2)
        self.layer.addSublayer(trashLayer3)
        
    }
    
    

    private func openCap() {
        
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setCompletionBlock { [weak self] in
            
            self?.trashLayer.transform = CATransform3DTranslate(CATransform3DMakeRotation(CGFloat(Double.pi) / 4, 0, 0, 1), 1, 0, 0)
            self?.trashLayer2.opacity = 0
            self?.trashLayer3.transform = CATransform3DTranslate(CATransform3DMakeRotation(-CGFloat(Double.pi) / 4, 0, 0, 1), -4, 4, 0)
        }
        CATransaction.begin()
        
        CATransaction.commit()
        

        
    }
    
    private func closeCap() {
        
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setCompletionBlock { [weak self] in
            
            self?.trashLayer.transform = CATransform3DIdentity
            self?.trashLayer2.opacity = 1
            self?.trashLayer3.transform = CATransform3DIdentity
        }
        CATransaction.begin()
        
        CATransaction.commit()

        

        
    }
    

}
