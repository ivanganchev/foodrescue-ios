//
//  MealsViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-26.
//

import UIKit

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMealIndex: Int? = nil
    @Published var reservedMeals: [Int: TimeComponents] = [:]
    
    let restaurant: Restaurant
    
    private let mealsService = MealsService()
    private let userSessionService: UserSessionService
    
    private let realTimeUpdatesManager = RealTimeUpdatesManager()
    
    init(userSessionService: UserSessionService, restaurant: Restaurant) {
        self.userSessionService = userSessionService
        self.restaurant = restaurant
        
        realTimeUpdatesManager.subscribe(to: .newMeal) { [weak self] (newMeal: Meal) in
            DispatchQueue.main.async {
                self?.meals.append(newMeal)
            }
        }
        
        realTimeUpdatesManager.subscribe(to: .deleteMeal) { [weak self] (deletedMeal: Meal) in
            DispatchQueue.main.async {
                self?.meals.removeAll { $0.id == deletedMeal.id }
            }
        }
    }
    
    deinit {
        realTimeUpdatesManager.disconnect()
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
    
    func reserveMeal(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let meal = meals[index]
        let id = meal.id
        
        mealsService.updateReservation(id, reserveTime: 2, userId: userSessionService.getUserId(), action: ReserveAction.reserve) { result in
            switch result {
            case .success(let reservationExpiration):
                guard let timeLeft = DateConverter.timeLeft(from: reservationExpiration) else { return }
                self.reservedMeals[index] = timeLeft
            case .failure(let error):
                print("Failed to reserve meal: \(error.localizedDescription)")
            }
        }
    }
    
//    func releaseMeal() {
//        mealsService.updateReservation(id, reserveTime: 1, userId: userSessionService.getUserId(), action: ReserveAction.reserve) { result in
//            switch result {
//            case .success(let reservationExpiration):
//                completion(reservationExpiration)
//            case .failure(let error):
//                print("Failed to reserve meal: \(error.localizedDescription)")
//            }
//        }
//    }
    
    func getMealsByRestaurantId(_ restaurantId: String) {
        mealsService.getMealsByRestaurantId(restaurantId) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
                
                for (index, meal) in meals.enumerated() {
                    if let reservationExpiresAt = meal.reservationExpiresAt,
                       let timeLeft = DateConverter.timeLeft(from: reservationExpiresAt) {
                        self?.reservedMeals[index] = timeLeft
                    }
                }
            case .failure(let error):
                print("Failed to fetch meals: \(error.localizedDescription)")
            }
        }
    }
    
    
    func isUserOwner() -> Bool {
        userSessionService.getUserId() == restaurant.ownerId
    }
}
