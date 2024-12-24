//
//  CreateMealsViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-24.
//

import Foundation
import UIKit
import SwiftUI

class CreateMealsViewController: UIViewController {
    private let restaurantViewModel: RestaurantViewModel
    let successCheckmarkView = SuccessCheckmarkView(message: "Created successfully!")
    
    var onFinishAddingMeal: ((Restaurant) -> Void)?
    
    init(restaurantViewModel: RestaurantViewModel) {
        self.restaurantViewModel = restaurantViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createMealView = UIHostingController(rootView: CreateMealView(cancelAction: cancelAddMeal, finishAction: finishAddMeal))
        
        successCheckmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(createMealView)
        view.addSubview(createMealView.view)
        view.addSubview(successCheckmarkView)
        
        createMealView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createMealView.view.topAnchor.constraint(equalTo: view.topAnchor),
            createMealView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createMealView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createMealView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            successCheckmarkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successCheckmarkView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        createMealView.didMove(toParent: self)
    }
    
    private func cancelAddMeal() {
        self.dismiss(animated: true)
    }
    
    private func finishAddMeal(name: String, description: String, price: String, image: UIImage) {
        restaurantViewModel.createRestaurantMeal(name: name, description: description, price: price, image: image) { [weak self] restaurant in
            self?.successCheckmarkView.show {
                self?.onFinishAddingMeal?(restaurant)
                self?.dismiss(animated: true)
            }
        }
    }
}
