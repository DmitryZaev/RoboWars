//
//  ViewController.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.mainView.addRobotsToView()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

