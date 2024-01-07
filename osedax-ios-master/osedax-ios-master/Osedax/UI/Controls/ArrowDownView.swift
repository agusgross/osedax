//
//  CancelAudioView.swift
//  radio
//
//  Created by Gustavo Rago on 3/20/21.
//  Copyright © 2021 Eduardo Holzmann. All rights reserved.
//

import UIKit

class ArrowDownView: UIView {
        
    let duration: CFTimeInterval = 1
    let trashLayer = CAShapeLayer()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addTrash()
        
    }
    
    func startAnimation(){
        
        isHidden = false
        
        arrowDown()
        
    }
    
    private func addTrash(){
        
        let trashPath = UIBezierPath()

        let fillColor = UIColor(named: "ColorAccent")

        
        trashPath.move(to: CGPoint(x: 2, y: 0))
        trashPath.addLine(to: CGPoint(x: 18, y: 12))
        trashPath.addLine(to: CGPoint(x: 33, y: 0))
        trashPath.addLine(to: CGPoint(x: 35, y: 3))
        trashPath.addLine(to: CGPoint(x: 18, y: 16))
        trashPath.addLine(to: CGPoint(x: 0, y: 3))
        trashPath.addLine(to: CGPoint(x: 2, y: 0))
        trashPath.lineWidth = 0
        trashPath.close()
        
        trashLayer.path = trashPath.cgPath
        trashLayer.position = CGPoint(x: 0, y: 0)
        
        //change the fill color
        trashLayer.fillColor = fillColor?.cgColor
        //you can change the stroke color
        trashLayer.strokeColor = UIColor.clear.cgColor
        trashLayer.opacity = 0



        self.layer.addSublayer(trashLayer)
        
    }
    
    private func arrowDown() {
               
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = 1000
        
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        translation.values = [0, 13, 25]
        translation.keyTimes = [0, 0.5, 1]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0, 1, 0]
        opacity.keyTimes = [0, 0.5, 1]
        

        group.animations = [translation, opacity]
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in

        }

        trashLayer.add(group, forKey: "firstThirdAnimation")

        CATransaction.commit()
        
    }


}
