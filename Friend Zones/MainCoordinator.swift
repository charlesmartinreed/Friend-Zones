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
        vc.coordinator = self //tell the VC how to talk to us when something interesting has happened
        navigationController.pushViewController(vc, animated: false)
    }
    
    //was originally in ViewController
    func configure(friend: Friend) {
        //create instance of FriendVC, assign self as delegate, assign selected friend as FriendVC's friend property and push the Friend VC onto the stack
        let vc = FriendViewController.instantiate()
        
        //update selected friend
        vc.coordinator = self
        vc.friend = friend
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func update(friend: Friend) {
        //this method will be called by the FriendViewController in this app, used to reflect editing changes
        
        //get root view controller and make sure it's the right type and then relay the update message to it
        guard let vc = navigationController.viewControllers.first as? ViewController else { return }
        vc.update(friend: friend)
        
    }
}
