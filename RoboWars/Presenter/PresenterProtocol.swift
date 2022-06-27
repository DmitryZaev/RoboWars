//
//  PresenterProtocol.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import Foundation

protocol PresenterProtocol: AnyObject {
    
    func configureSelfAndStart()
    
    func tellWhoWin()
    
    func restartGame()
}

