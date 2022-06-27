//
//  SoundManager.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 29.05.2022.
//

import Foundation
import AVFoundation

let soundExtension = "mp3"
var bulletPlayer = AVPlayer()
var blasterPlayer = AVPlayer()
var rocketPlayer = AVPlayer()
var boomPlayer = AVPlayer()
var hitPlayer = AVPlayer()
var penetrationPlayer = AVPlayer()
var winPlayer = AVPlayer()

class SoundManager {
    
    enum Sounds: String {
        case bullet = "bullet"
        case rocket = "rocket"
        case blaster = "blaster"
        case boom = "boom"
        case hit = "hit"
        case penetration = "penetration"
        case terrWin = "terrWin"
        case countTerrWin = "countTerrWin"
    }
    
    static func play(sound: Sounds) {
        guard let track = Bundle.main.url(forResource: sound.rawValue, withExtension: soundExtension) else { return }
        switch sound {
        case .bullet:
            bulletPlayer = AVPlayer(url: track)
            bulletPlayer.volume = 0.2
            bulletPlayer.play()
        case .blaster:
            blasterPlayer = AVPlayer(url: track)
            blasterPlayer.volume = 0.2
            blasterPlayer.play()
        case .rocket:
            rocketPlayer = AVPlayer(url: track)
            rocketPlayer.volume = 0.2
            rocketPlayer.play()
        case .boom:
            bulletPlayer.pause()
            blasterPlayer.pause()
            rocketPlayer.pause()
            boomPlayer = AVPlayer(url: track)
            boomPlayer.volume = 0.4
            boomPlayer.play()
        case .hit:
            hitPlayer = AVPlayer(url: track)
            hitPlayer.volume = 0.05
            hitPlayer.play()
        case .penetration:
            penetrationPlayer = AVPlayer(url: track)
            penetrationPlayer.volume = 0.1
            penetrationPlayer.play()
        case .terrWin, .countTerrWin:
            winPlayer = AVPlayer(url: track)
            winPlayer.volume = 0.3
            winPlayer.play()
        }
    }
}
