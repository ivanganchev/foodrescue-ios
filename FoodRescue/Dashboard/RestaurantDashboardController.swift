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
    
    let mealsViewModel: MealsViewModel
    
    private lazy var restaurantDashboardView: RestaurantDashboardView = {
        RestaurantDashboardView(
            restaurantName: restaurant.name,
            viewModel: mealsViewModel,
            createMealAction: showCreateMealController
        )
    }()
    
    init(mealsViewModel: MealsViewModel, restaurant: Restaurant) {
        self.restaurant = restaurant
        self.mealsViewModel = mealsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let restaurantDashboard = UIHostingController(rootView: restaurantDashboardView)
        
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
    
    private func showCreateMealController() {
        guard let restaurantId = restaurant.id else {
            return
        }
        
        let createMealController = CreateMealsViewController(mealsViewModel: mealsViewModel, restaurantId: restaurantId)
        createMealController.modalPresentationStyle = .fullScreen

        createMealController.onFinishAddingMeal = {}
        
        self.present(createMealController, animated: true, completion: nil)
    }
}
