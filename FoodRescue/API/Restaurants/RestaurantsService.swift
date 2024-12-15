//
//  RestaurantsService.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-01.
//

import Foundation
import Alamofire
import UIKit

class RestaurantsService {
    var jwtAuthenticator = JWTAuthentication()
    
    func createRestaurant(name: String, description: String, image: UIImage, latitude: Double, longitude: Double, completion: @escaping (Result<Restaurant, Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else { return }
        
        let url = "https://foodrescue-api.onrender.com/restaurants/create"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        print("Token:", token)
        print("Token is: \(headers["Authorization"]!)")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(name.data(using: .utf8)!, withName: "name")
                
                multipartFormData.append(description.data(using: .utf8)!, withName: "description")
                
                multipartFormData.append(imageData, withName: "image", fileName: "restaurant.jpg", mimeType: "image/jpeg")
                
                multipartFormData.append(String(latitude).data(using: .utf8)!, withName: "latitude")
                
                multipartFormData.append(String(longitude).data(using: .utf8)!, withName: "longitude")
            },
            to: url,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let restaurantResponse = try JSONDecoder().decode(Restaurant.self, from: data)
                    completion(.success(restaurantResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAllRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else { return }
        
        let url = "https://foodrescue-api.onrender.com/restaurants"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
            
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                    completion(.success(restaurants))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}

