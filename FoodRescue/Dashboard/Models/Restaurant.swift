//
//  Restaurant.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-01.
//

import Foundation

struct Restaurant: Decodable {
    let id: String
    let ownerId: String
    let name: String
    let description: String
    let images: [String]
    let latitude: Double
    let longitude: Double
    var annotationId: String?
}
