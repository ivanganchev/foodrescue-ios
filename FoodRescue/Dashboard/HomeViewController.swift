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
            ? AnyView(CustomerHomeView(locationManager: LocationManager(), viewModel: restaurantViewModel, restaurantTapAction: {
                [weak self] restaurant in
                guard let self = self else { return }
                
                let restaurantDashboard = RestaurantDashboardController(mealsViewModel: MealsViewModel(userSessionService: self.userSessionService))
                restaurantDashboard.mealsViewModel.setCurrentRestaurant(restaurant)
                restaurantDashboard.modalPresentationStyle = .pageSheet
        
                self.present(restaurantDashboard, animated: true, completion: nil)
            }))
            : AnyView(OwnerHomeView(restaurantViewModel: restaurantViewModel, mealsViewModel: mealsViewModel, userSession: userSessionService))
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
