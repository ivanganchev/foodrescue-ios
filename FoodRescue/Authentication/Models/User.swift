//
//  User.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-03.
//

import Foundation
import RealmSwift

enum Role: String, PersistableEnum, Codable {
    case Customer = "Customer"
    case Owner = "Owner"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "Customer":
            self = .Customer
        case "Owner":
            self = .Owner
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize Role from invalid String value \(rawValue)"
            )
        }
    }
}

struct User: Codable {
    var id: String
    var username: String
    var email: String
    var role: Role?
}

