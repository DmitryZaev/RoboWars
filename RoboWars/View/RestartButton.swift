//
//  RestartButton.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 29.05.2022.
//

import UIKit

class RestartButton: UIButton {

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        configureSelf()
        addBlur()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        setTitle("R E S T A R T", for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 30)
        setTitleColor(.black.withAlphaComponent(0.3), for: .normal)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = bounds.height / 3
        backgroundColor = .clear
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = frame
        blurView.layer.cornerRadius = layer.cornerRadius
        blurView.layer.masksToBounds = true
        blurView.isUserInteractionEnabled = false
        addSubview(blurView)
        sendSubviewToBack(blurView)
    }
    
   
}
