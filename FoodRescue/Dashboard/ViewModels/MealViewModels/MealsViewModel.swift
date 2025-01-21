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
    @Published var reservedMeals: [String: TimeComponents] = [:]
    
    var restaurant: Restaurant?
    
    private let mealsService = MealsService()
    let userSessionService: UserSessionService
    
    private let realTimeUpdatesManager = RealTimeUpdatesManager()
    
    var mealsByRestaurant: [(restaurant: String, meals: [Meal])] {
        Dictionary(grouping: meals, by: { $0.restaurantId })
            .map { (key: String, value: [Meal]) in (restaurant: key, meals: value) }
            .sorted { $0.restaurant < $1.restaurant }
    }
    
    init(userSessionService: UserSessionService) {
        self.userSessionService = userSessionService
        
        realTimeUpdatesManager.subscribe(to: .newMeal) { [weak self] (newMeal: Meal) in
            DispatchQueue.main.async {
                guard self?.userSessionService.getUserId() != self?.restaurant?.ownerId else { return }
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
    
    func setCurrentRestaurant(_ restaurant: Restaurant) {
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
    
    func reserveMeal(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let meal = meals[index]
        let id = meal.id
        
        mealsService.updateReservation(id, reserveTime: 2, userId: userSessionService.getUserId(), action: ReserveAction.reserve) { result in
            switch result {
            case .success(let reservationExpiration):
                guard let timeLeft = DateConverter.timeLeft(from: reservationExpiration) else { return }
                self.reservedMeals[id] = timeLeft
            case .failure(let error):
                print("Failed to reserve meal: \(error.localizedDescription)")
            }
        }
    }
    
    func getMealsByRestaurantIds(_ restaurantIds: [String]) {
        mealsService.getMealsByRestaurantIds(restaurantIds) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
                
                for (index, meal) in meals.enumerated() {                    
                    if let reservationExpiresAt = meal.reservationExpiresAt,
                       let timeLeft = DateConverter.timeLeft(from: reservationExpiresAt) {
                        self?.reservedMeals[meal.id] = timeLeft
                    }
                }
            case .failure(let error):
                print("Failed to fetch meals: \(error.localizedDescription)")
            }
        }
    }
    
    
    func isUserOwner() -> Bool {
        userSessionService.getUserId() == restaurant?.ownerId
    }
    
    func updateTimers() {
        TimerUtility.updateTimers(reservedMeals: &reservedMeals)
    }
}
