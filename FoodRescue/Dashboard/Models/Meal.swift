//
//  Meal.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-15.
//

import Foundation

struct Meal: Decodable {
    let name: String
    let description: String
    let image: String
    let price: String
    let restaurantId: String
}

extension Meal: Identifiable {
    var id: String {
        UUID().uuidString
    }
}
    

