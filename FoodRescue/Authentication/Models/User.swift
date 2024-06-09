//
//  User.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-03.
//

import Foundation
import RealmSwift

enum Role: String, PersistableEnum, Codable {
    case Client = "Client"
    case Owner = "Owner"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "Client":
            self = .Client
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
    var username: String?
    var email: String?
    var role: Role?
}

