//
//  RestaurantViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-01.
//

import Foundation
import UIKit
import CoreLocation

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    let restaurantService = RestaurantsService()
    private let realTimeUpdatesManager = RealTimeUpdatesManager()
    
    var onRestaurantAdded: ((Restaurant) -> Void)?
    
    init() {
        realTimeUpdatesManager.subscribe(to: .newRestaurant) { [weak self] (newRestaurant: Restaurant) in
            DispatchQueue.main.async {
                if let onRestaurantAdded = self?.onRestaurantAdded {
                    self?.restaurants.append(newRestaurant)
                    onRestaurantAdded(newRestaurant)
                }
            }
        }
    }
    
    deinit {
        realTimeUpdatesManager.disconnect()
    }
    
    func createRestaurant(ownerId: String, name: String, description: String, image: UIImage, latitude: Double, longitude: Double, completion: @escaping (Restaurant) -> Void) {
        restaurantService.createRestaurant(ownerId: ownerId, name: name, description: description, image: image, latitude: latitude , longitude: longitude, completion: { result in
            switch result {
            case .success(let restaurantResponse):
                print("Successfully created restaurant!")
                completion(restaurantResponse)
            case .failure(let error):
                print("Failed to create restaurant: \(error.localizedDescription)")
            }
        })
    }
    
    func getAllRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        restaurantService.getAllRestaurants { result in
            switch result {
            case .success(let restaurants):
                completion(restaurants)
            case .failure(let error):
                print("Failed to fetch restaurants: \(error.localizedDescription)")
            }
        }
    }
    
    func getAllRestaurants(for ownerId: String, completion: (([Restaurant]) -> Void)? = nil) {
        restaurantService.getAllRestaurants(for: ownerId) { [weak self] result in
            switch result {
            case .success(let restaurants):
                self?.restaurants = restaurants
                completion?(restaurants)
            case .failure(let error):
                print("Failed to fetch restaurants: \(error.localizedDescription)")
            }
        }
    }
    
    func getAllNearbyRestaurants(userLatitude: Double, userLongitude: Double, maxDistance: Double) {
        restaurantService.getAllRestaurants { [weak self] result in
            switch result {
            case .success(let restaurants):
                let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
                let nearbyRestaurants = restaurants.filter { restaurant in
                    let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
                    let distance = userLocation.distance(to: restaurantLocation)
                    return distance <= maxDistance
                }
                DispatchQueue.main.async {
                    self?.restaurants = nearbyRestaurants
                }
            case .failure(let error):
                print("Failed to fetch restaurants: \(error.localizedDescription)")
            }
        }
    }
    
    func getRestaurantById(_ id: String) -> Restaurant? {
        return restaurants.filter { $0.id == id }.first
    }
}
