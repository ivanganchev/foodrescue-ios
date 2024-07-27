//
//  AuthenticationService.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-03.
//

import Foundation
import Alamofire
import RealmSwift

class AuthenticationService {
    var jwtAuthenticator = JWTAuthentication()
    
    func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] =  [
            "username": username,
            "password": password
        ]
        
        AF.request("https://foodrescue-api.onrender.com/users/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { response in
            switch response.result {
                case .success(let data):
                do {
                    let authResponse: AuthResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    
                    self.saveUserDataLocally(authResponse)
                    
                    completion(.success(()))
                } catch {
                    print(error)
                }
                case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func register(username: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] =  [
            "userId": UUID().uuidString.lowercased(),
            "username": username,
            "email": email,
            "password": password
        ]
        
        AF.request("https://foodrescue-api.onrender.com/users/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseData { response in
            switch response.result {
                case .success(let data):
                do {
                    let authResponse: AuthResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    
                    self.saveUserDataLocally(authResponse)
                    
                    completion(.success(()))
                } catch {
                    print(error)
                }
                case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyToken(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = jwtAuthenticator.keychain.get("token") else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No token"])
            completion(.failure(error))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        AF.request("https://foodrescue-api.onrender.com/users/verify-token", headers: headers).responseData { response in
            switch response.result {
            case .success(_):
                if let httpResponse = response.response, httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveUserDataLocally(_ authResponse: AuthResponse) {
        guard let token = authResponse.token else {
            print("No token provided")
            return
        }
        
        self.jwtAuthenticator.storeJWToken(token)
        
        do {
            let realm = try Realm()
            let user = UserDB(user: User(id: authResponse.user.id,
                                         username: authResponse.user.username,
                                         email: authResponse.user.email,
                                         role: authResponse.user.role))
            
            realm.safeWrite {
                realm.add(user, update: .modified)
                print("Successfuly user added to realm!")
            }
        } catch {
            print(error)
        }
    }
}
