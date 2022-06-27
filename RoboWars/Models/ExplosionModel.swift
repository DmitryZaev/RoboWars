//
//  ExplosionModel.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 28.05.2022.
//

import Foundation

protocol Explosion {
    var height: Int { get }
    var width: Int { get }
    var imageName: String { get }
    var centerX: Int { get set }
    var centerY: Int { get set }
}

struct AcrossExplosion: Explosion {
    let height = 120
    let width = 120
    let imageName = "across"
    var centerX: Int
    var centerY: Int
}

struct Smoke: Explosion {
    let height = 60
    let width = 60
    let imageName = "smoke"
    var centerX: Int
    var centerY: Int
}

struct Hit: Explosion {
    let height = 45
    let width = 45
    let imageName = "hit"
    var centerX: Int
    var centerY: Int
}

struct FinalExplosion: Explosion {
    let height = 150
    let width = 150
    let imageName = "roboboom"
    let deathRobotImageName = "debris"
    var centerX: Int
    var centerY: Int
    
}
    
