//
//  MealsService.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-26.
//

import Alamofire
import UIKit

class MealsService: BaseService {
    func createMeal(name: String, description: String, price: String, image: UIImage, restaurantId: String, completion: @escaping (Result<Meal, Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else { return }
        
        let url = "https://foodrescue-api.onrender.com/meals/create"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(name.data(using: .utf8)!, withName: "name")
                multipartFormData.append(description.data(using: .utf8)!, withName: "description")
                multipartFormData.append(price.data(using: .utf8)!, withName: "price")
                multipartFormData.append(imageData, withName: "image", fileName: "meal.jpg", mimeType: "image/jpeg")
                multipartFormData.append(restaurantId.data(using: .utf8)!, withName: "restaurantId")
            },
            to: url,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let meal = try JSONDecoder().decode(Meal.self, from: data)
                    completion(.success(meal))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
