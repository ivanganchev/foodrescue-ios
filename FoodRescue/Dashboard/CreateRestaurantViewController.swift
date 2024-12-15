//
//  CreateRestaurantViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-08-10.
//

import UIKit
import SwiftUI

class CreateRestaurantViewController: UIViewController {
    private let restaurantViewModel: RestaurantViewModel
    let successCheckmarkView = SuccessCheckmarkView(message: "Created successfully!")
    
    let restaurantLatitude: Double
    let restaurantLongitude: Double
    
    var onFinishAddingRestaurant: ((Restaurant) -> Void)?
    
    init(latitude: Double, longitude: Double, restaurantViewModel: RestaurantViewModel) {
        self.restaurantLatitude = latitude
        self.restaurantLongitude = longitude
        self.restaurantViewModel = restaurantViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createRestaurantView = UIHostingController(rootView: CreateRestaurantView(cancelAction: cancelAddRestaurant, finishAction: finishAddRestaurant))
        
        successCheckmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(createRestaurantView)
        view.addSubview(createRestaurantView.view)
        view.addSubview(successCheckmarkView)
        
        createRestaurantView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createRestaurantView.view.topAnchor.constraint(equalTo: view.topAnchor),
            createRestaurantView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createRestaurantView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createRestaurantView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            successCheckmarkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successCheckmarkView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        createRestaurantView.didMove(toParent: self)
    }
    
    private func cancelAddRestaurant() {
        self.dismiss(animated: true)
    }
    
    private func finishAddRestaurant(name: String, description: String, image: UIImage) {
        restaurantViewModel.createRestaurant(name: name, description: description, image: image, latitude: restaurantLatitude, longitude: restaurantLongitude) { [weak self] restaurant in
            self?.successCheckmarkView.show {
                self?.onFinishAddingRestaurant?(restaurant)
                self?.dismiss(animated: true)
            }
        }
    }
}
