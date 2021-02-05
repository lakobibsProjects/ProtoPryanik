
//
//  MainCoordinator.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController()
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func toDescription(){
        
    }
}
