//
//  MealsViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-26.
//

import UIKit

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    let restaurant: Restaurant
    
    private let mealsService = MealsService()
    private let userSessionService: UserSessionService
    
    init(userSessionService: UserSessionService, restaurant: Restaurant) {
        self.userSessionService = userSessionService
        self.restaurant = restaurant
    }
    
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
    
    func deleteMealById(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let deletedMeal = meals[index]
        let id = deletedMeal.id
        
        mealsService.deleteMealById(id) { [weak self] result in
            switch result {
            case .success:
                self?.meals.removeAll { $0.id == id }
                print(self?.meals.count)
            case .failure(let error):
                print("Failed to delete meal: \(error.localizedDescription)")
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
    
    
    func isUserOwner() -> Bool {
        userSessionService.getUserId() == restaurant.ownerId
    }
}
