//
//  MealsService.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-26.
//

import UIKit
import Alamofire
import RealmSwift

enum ReserveAction: String {
    case reserve = "reserve"
    case release = "release"
}

class MealsService: BaseService {
    func createMeal(name: String, description: String, price: String, image: UIImage, restaurantId: String, completion: @escaping (Result<Meal, Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else { return }
        
        let url = "https://foodrescue-api.onrender.com/meals/create"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
            return
        }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(UUID().uuidString.lowercased().data(using: .utf8)!, withName: "id")
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
    
    func deleteMealById(_ id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }
        
        let url = "https://foodrescue-api.onrender.com/meals/delete/\(id)"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        AF.request(url, method: .delete, headers: headers).responseData { response in
            switch response.result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateReservation(_ mealId: String, reserveTime: Int, userId: String, action: ReserveAction, completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
            return
        }
        
        let url = "https://foodrescue-api.onrender.com/meals/updateReservation"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        let parameters: [String: Any] = [
            "id": mealId,
            "reservationTime": reserveTime,
            "userId": userId,
            "action": action.rawValue
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData {[weak self] response in
            switch response.result {
            case .success(let data):
                do {
                    let reservationResponse = try JSONDecoder().decode(ReservationResponse.self, from: data)
                    
//                    self?.updateMealReservation(mealId: mealId, expirationTime: reservationResponse.reservationExpiresAt, reserverId: userId)
                    
                    completion(.success((reservationResponse.reservationExpiresAt)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMealsByRestaurantIds(_ ids: [String], completion: @escaping (Result<[Meal], Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else { return }
        
        let url = "https://foodrescue-api.onrender.com/meals/by-restaurants"
        let headers: HTTPHeaders = [
            "Authorization": "\(token)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "restaurantIds": ids
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let meals = try JSONDecoder().decode([Meal].self, from: data)
                    completion(.success(meals))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Realm Service
extension MealsService {
    func saveMeal(_ meal: Meal) {
        do {
            let realm = try Realm()
            
            realm.safeWrite {
                realm.add(MealDB(meal: meal))
                print("Successfully added Meal")
            }
        } catch {
            print(error)
        }
    }
    
    func updateMealReservation(mealId: String, expirationTime: String?, reserverId: String?) {
        do {
            let realm = try Realm()
            
            guard let meal = realm.object(ofType: MealDB.self, forPrimaryKey: mealId) else { return }
            
            realm.safeWrite {
                meal.reservationExpiresAt = expirationTime
                meal.reservedBy = reserverId
            }
        } catch {
            print(error)
        }
    }
}
