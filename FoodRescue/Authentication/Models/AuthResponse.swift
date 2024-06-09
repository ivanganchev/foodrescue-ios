//
//  AuthResponse.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-03.
//

import Foundation

struct AuthResponse: Codable {
    var token: String?
    var message: String
    var user: User
}
