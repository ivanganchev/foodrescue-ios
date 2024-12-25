//
//  RestaurantDashboardController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-24.
//

import Foundation
import UIKit
import SwiftUI

class RestaurantDashboardController: UIViewController {
    let restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let restaurantDashboard = UIHostingController(rootView: RestaurantDashboardView(restaurantName: restaurant.name, meals: [
            ]))
        
        addChild(restaurantDashboard)
        view.addSubview(restaurantDashboard.view)
        
        restaurantDashboard.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restaurantDashboard.view.topAnchor.constraint(equalTo: view.topAnchor),
            restaurantDashboard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            restaurantDashboard.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            restaurantDashboard.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        restaurantDashboard.didMove(toParent: self)
    }
}
