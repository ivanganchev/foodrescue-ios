//
//  Meal.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-15.
//

import Foundation

struct Meal: Decodable, Identifiable {
    var id: String
    let name: String
    let description: String
    let image: String
    let price: String
    let restaurantId: String
    let reservationExpiresAt: String?
    let reservedBy: String?
    let reserved: Bool?
}
    

