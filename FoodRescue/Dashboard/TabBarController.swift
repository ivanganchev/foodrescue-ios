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
        let profileViewController = ProfileViewController()
        
        let firstNavController = UINavigationController(rootViewController: homeViewController)
        let secondNavController = UINavigationController(rootViewController: mapViewController)
        let thirdNavController = UINavigationController(rootViewController: profileViewController)
        
        firstNavController.tabBarItem.title = "Home"
        firstNavController.tabBarItem.image = UIImage(systemName: "house")
        
        secondNavController.tabBarItem.title = "Map"
        secondNavController.tabBarItem.image = UIImage(systemName: "map")
        
        thirdNavController.tabBarItem.title = "Profile"
        thirdNavController.tabBarItem.image = UIImage(systemName: "person")
        
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        
        self.viewControllers = [firstNavController, secondNavController, thirdNavController]
    }
}
