//
//  MealDB.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-13.
//

import Foundation
import RealmSwift

class MealDB: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var mealDescription: String
    @Persisted var image: String
    @Persisted var price: String
    @Persisted var restaurantId: String
    @Persisted var reservationExpiresAt: String?
    @Persisted var reservedBy: String?
    @Persisted var reserved: Bool
    
    convenience init(meal: Meal) {
        self.init()
        
        self.id = meal.id
        self.name = meal.name
        self.mealDescription = meal.description
        self.image = meal.image
        self.price = meal.price
        self.restaurantId = meal.restaurantId
        self.reservationExpiresAt = meal.reservationExpiresAt
        self.reservedBy = meal.reservedBy
        self.reserved = reserved
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
