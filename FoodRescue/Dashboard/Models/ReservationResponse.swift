//
//  ReservationResponse.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-12.
//

import Foundation

struct ReservationResponse: Decodable {
    let id: String?
    let reservationExpiresAt: String?
    let reservedBy: String?
}
