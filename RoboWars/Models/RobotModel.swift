//
//  RobotModel.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import Foundation

protocol Robot {
    var tag : Int { get }
    var height: Int { get }
    var width: Int { get }
    var imageName: String { get }
    var originX: Int { get set }
    var centerX: Int { get }
    var originY: Int { get set }
    var centerY: Int { get }
    var verticalBody: ClosedRange<Int> { get }
    var horizontalBody: ClosedRange<Int> { get }
    var rightHandPosition: Int { get }
    var leftHandPosition: Int { get }
    var haveAmmo: Bool { get set }
    var runAway: Bool { get set }
    var stepOfRun: Int { get set }
    var runDirection: String { get set }
    
    mutating func checkStillNeedRun()
}

extension Robot {
    var height: Int {
        return 40
    }
    var width: Int {
        return 60
    }
    var centerX: Int {
        return originX + (width / 2)
    }
    var centerY: Int {
        return originY + (height / 2)
    }
    var verticalBody: ClosedRange<Int> {
        return originY...(originY + height)
    }
    var horizontalBody: ClosedRange<Int> {
        return originX...(originX + width)
    }
    
    mutating func checkStillNeedRun() {
        self.runAway = (stepOfRun < 40)
    }
}


struct TopRobot: Robot {
    let tag = 0
    var originX = 100
    var originY = 0
    let imageName = "topRobot"
    var rightHandPosition: Int {
        return originX + (width / 10)
    }
    var leftHandPosition: Int {
        return originX + width - (width / 10)
    }
    var haveAmmo = true
    var runAway = false
    var stepOfRun = 0
    var runDirection = ""
}

struct BottomRobot: Robot {
    var tag = 1
    var originX = 100
    var originY = 0
    let imageName = "bottomRobot"
    var rightHandPosition: Int {
        return originX + width - (width / 10)
    }
    var leftHandPosition: Int {
        return originX + (width / 10)
    }
    var haveAmmo = true
    var runAway = false
    var stepOfRun = 0
    var runDirection = ""
}

