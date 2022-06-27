//
//  BulletModel.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import Foundation

enum BulletType: Int, CaseIterable {
    case bullet = 0
    case blaster = 1
    case rocket = 2
}

protocol Bullet {
    var type: BulletType { get set }
    var imageName: String { get }
    var images: [String] { get }
    var height: Int { get }
    var width: Int { get }
    var centerX: Int { get }
    var centerY: Int { get }
    var originX: Int { get }
    var originY: Int { get set }
    var horizontalBody: ClosedRange<Int> { get }
    var verticalBody: ClosedRange<Int> { get }
    var tag: Int { get set }
    var facePosition : Int { get }
    var backPosition : Int { get }
    var indexInArray: Int { get set }
    
    mutating func fly()
}

extension Bullet {
    var imageName: String {
        return images[type.rawValue]
    }
    var height: Int {
        return 30
    }
    var width: Int {
        return 10
    }
    var originX: Int {
        centerX - (width / 2)
    }
    var centerY: Int {
        originY + (height / 2)
    }
    var horizontalBody: ClosedRange<Int> {
        return originX...(originX + width)
    }
    var verticalBody: ClosedRange<Int> {
        return originY...(originY + height)
    }
}

struct TopBullet: Bullet {
    var type = BulletType.allCases.randomElement()!
    let images = ["topBullet", "topBullet2", "topRocket"]
    var centerX: Int
    var originY = 0
    var tag: Int
    var facePosition: Int {
       return originY + height
    }
    var backPosition: Int {
        return originY
    }
    var indexInArray = 0
    
    mutating func fly() {
        originY += 20
    }
}

struct BottomBullet: Bullet {
    var type = BulletType.allCases.randomElement()!
    let images = ["bottomBullet", "bottomBullet2", "bottomRocket"]
    var centerX: Int
    var originY = 0
    var tag: Int
    var facePosition: Int {
        return originY
    }
    var backPosition: Int {
        return originY + height
    }
    var indexInArray = 0
    
    mutating func fly() {
        originY -= 20
    }
}
