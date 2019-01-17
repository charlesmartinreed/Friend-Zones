//
//  MainCoordinator.swift
//  Friend Zones
//
//  Created by Charles Martin Reed on 1/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    //class rather than struct because multiple instances of a view controller will all point to the same MainCoordinator. We need to all grab a reference to THIS, which classes allow for better or worse (in this case, better)
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        //has to instantiate the main view controller class (ViewController) and show it in the nav controller
        //will also be used to show other view controllers along the way
        
        let vc = ViewController.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
}
