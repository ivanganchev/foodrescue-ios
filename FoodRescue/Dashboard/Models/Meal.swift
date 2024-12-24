//
//  Meal.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-15.
//

import Foundation

struct Meal: Decodable {
    let id: String?
    let name: String
    let description: String
    let image: String
    let price: Double
    let restaurantId: String
}

