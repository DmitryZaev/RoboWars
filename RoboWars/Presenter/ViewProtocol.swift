//
//  ViewProtocol.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import Foundation

protocol ViewProtocol: AnyObject {
    
    func addBackground(with name: String)
    
    func showRobotsImages(topRobot: Robot, bottomRobot: Robot)
    
    func updateRobotsImagesPositions(topRobot: Robot, bottomRobot: Robot)
    
    func showBulletImage(_ bullet: Bullet, with smoke: Smoke)
    
    func updateBulletsImagesPositions(_ bullets: [Bullet])
    
    func removeBulletImageWith(tag: Int)
    
    func removeBulletImageWith(tag: Int, with hit: Hit)
    
    func destroyRobot(tag: Int, with explosion: FinalExplosion)
    
    func removeAllBulletImages(with explosion: AcrossExplosion)
    
    func addScoreViewAndButton(widh score: Score, and button: RestartButtonModel)
}
