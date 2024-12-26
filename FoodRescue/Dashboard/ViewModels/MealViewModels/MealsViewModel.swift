//
//  MealsViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-26.
//

import UIKit

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    private let mealsService = MealsService()
    
    func createMeal(name: String, description: String, price: String, image: UIImage, restaurantId: String, completion: @escaping () -> Void) {
        mealsService.createMeal(name: name, description: description, price: price, image: image, restaurantId: restaurantId) { [weak self] result in
            switch result {
            case .success(let meal):
                self?.meals.append(meal)
                completion()
            case .failure(let error):
                print("Failed to create meal: \(error.localizedDescription)")
            }
        }
    }
    
    func getMealsByRestaurantId(_ restaurantId: String) {
        mealsService.getMealsByRestaurantId(restaurantId) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
            case .failure(let error):
                print("Failed to fetch meals: \(error.localizedDescription)")
            }
        }
    }
}
