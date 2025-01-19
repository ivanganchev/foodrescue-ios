//
//  HomeViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-07-28.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    private let restaurantViewModel = RestaurantViewModel()
    private let userSessionService = UserSessionService()
    private lazy var mealsViewModel: MealsViewModel = {
        return MealsViewModel(userSessionService: userSessionService)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeView = UIHostingController(rootView: HomeView(restaurantViewModel: restaurantViewModel, mealsViewModel: mealsViewModel))
    }
}
