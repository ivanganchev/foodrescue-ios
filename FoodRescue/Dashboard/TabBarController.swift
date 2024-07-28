//
//  TabBarController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-06-15.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = HomeViewController()
        let mapViewController = MapViewController()
        
        let firstNavController = UINavigationController(rootViewController: homeViewController)
        let secondNavController = UINavigationController(rootViewController: mapViewController)
        
        firstNavController.tabBarItem.title = "Home"
        firstNavController.tabBarItem.image = UIImage(systemName: "house")
        
        secondNavController.tabBarItem.title = "Map"
        secondNavController.tabBarItem.image = UIImage(systemName: "map")
        
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        
        self.viewControllers = [firstNavController, secondNavController]
    }
}
