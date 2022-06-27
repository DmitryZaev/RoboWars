//
//  MvpAssembler.swift
//  RoboWars
//
//  Created by Dmitry Victorovich on 27.05.2022.
//

import Foundation

class MvpAssembler {
    
    static func configureView() -> ViewController {
        
        let viewController = ViewController()
        let presenter = Presenter()
        
        guard let myView = viewController.view as? MainView else { return viewController }
        myView.presenter = presenter
        presenter.view = myView
        
        return viewController
    }
}
