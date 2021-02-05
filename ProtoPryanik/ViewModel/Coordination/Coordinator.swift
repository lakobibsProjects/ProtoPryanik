//
//  Coordinator.swift
//  ProtoPryanik
//
//  Created by user166683 on 2/3/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit

//TODO: change comments
///Coordinator that describe logic of segeues
protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    ///Initiate navigation with root VC
    func start()
}
