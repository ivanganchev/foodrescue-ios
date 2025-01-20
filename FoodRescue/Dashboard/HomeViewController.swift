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
        
        restaurantViewModel.getAllRestaurants(for: userSessionService.getUserId()) { [weak self] restaurants in
            self?.mealsViewModel.getMealsByRestaurantIds(restaurants.map { $0.id })
        }
                                                        
        let homeView = UIHostingController(
            rootView: userSessionService.getUserRole() == .customer
                ? AnyView(CustomerHomeView())
                : AnyView(OwnerHomeView(viewModel: mealsViewModel))
        )
        
        addChild(homeView)
        view.addSubview(homeView.view)
        
        homeView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeView.view.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        homeView.didMove(toParent: self)
    }
}
