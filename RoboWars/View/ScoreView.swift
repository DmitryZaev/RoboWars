//
//  ScoreView.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 29.05.2022.
//

import UIKit

class ScoreView: UIView {
    
    var topRobotScore: Int!
    var bottomRobotScore: Int!
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    private let transparent = 0.9
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSelf()
        addShadow()
        addGradient()
        addLine()
        addScoreLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.brown.cgColor
        layer.cornerRadius = bounds.height / 3
        alpha = transparent
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame.size = frame.size
        gradient.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = bounds.height / 3
        layer.insertSublayer(gradient, at: 2)
    }
    
    private func addLine() {
        let line = UIView()
        line.frame.size = CGSize(width: bounds.width,
                           height: 1)
        line.center = center
        line.backgroundColor = .brown
        line.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/8))
        addSubview(line)
    }
    
    private func addScoreLabels() {
        topLabel.frame.size = CGSize(width: bounds.height / 5,
                                     height: bounds.width / 4)
        topLabel.center = CGPoint(x: bounds.width / 4,
                                  y: bounds.height / 3)
        topLabel.textColor = .red
        topLabel.font = .boldSystemFont(ofSize: bounds.height / 4)
        topLabel.textAlignment = .center
        addSubview(topLabel)
        
        bottomLabel.frame.size = CGSize(width: bounds.height / 5,
                                     	height: bounds.width / 4)
        bottomLabel.center = CGPoint(x: bounds.width - (bounds.width / 4),
                                     y: bounds.height - (bounds.height / 3))
        bottomLabel.textColor = .blue
        bottomLabel.font = .boldSystemFont(ofSize: bounds.height / 4)
        bottomLabel.textAlignment = .center
        addSubview(bottomLabel)
    }
    
    private func addShadow() {
        let redShadowLayer = CAShapeLayer()
        redShadowLayer.path = UIBezierPath(roundedRect: self.frame,
                                        	cornerRadius: bounds.height / 3).cgPath
        redShadowLayer.shadowColor = UIColor.red.cgColor
        redShadowLayer.shadowOffset = CGSize(width: 20,
                                          	  height: 20)
        redShadowLayer.shadowOpacity = 1
        redShadowLayer.shadowRadius = 30
        
        layer.insertSublayer(redShadowLayer, at: 0)
        
        let blueShadowLayer = CAShapeLayer()
        blueShadowLayer.path = UIBezierPath(roundedRect: self.frame,
                                            cornerRadius: bounds.height / 3).cgPath
        blueShadowLayer.shadowColor = UIColor.blue.cgColor
        blueShadowLayer.shadowOffset = CGSize(width: -20,
                                             height: -20)
        blueShadowLayer.shadowOpacity = 1
        blueShadowLayer.shadowRadius = 30
        
        layer.insertSublayer(blueShadowLayer, at: 1)
    }
    
    func updateScore() {
        topLabel.text = String(topRobotScore)
        bottomLabel.text = String(bottomRobotScore)
    }
}
