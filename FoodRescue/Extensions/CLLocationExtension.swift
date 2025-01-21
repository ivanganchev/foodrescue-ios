//
//  CLLocationExtension.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-21.
//

import Foundation
import CoreLocation

extension CLLocation {
    func distance(to location: CLLocation) -> Double {
        return self.distance(from: location)
    }
}
