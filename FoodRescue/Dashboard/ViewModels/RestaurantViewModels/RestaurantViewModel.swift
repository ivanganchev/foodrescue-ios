//
//  RestaurantViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-01.
//

import Foundation
import UIKit

class RestaurantViewModel {
    let restaurantService = RestaurantsService()
    
    func createRestaurant(name: String, description: String, image: UIImage, latitude: Double, longitude: Double, completion: @escaping (Restaurant) -> Void) {
        restaurantService.createRestaurant(name: name, description: description, image: image, latitude: latitude , longitude: longitude, completion: { result in
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
}
