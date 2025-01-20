//
//  RoleSelectionService.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-06-09.
//

import Foundation
import Alamofire
import RealmSwift

class RoleSelectionService: BaseService {
    func selectRole(role: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // TODO: Handle better failure
        guard let token = jwtAuthenticator.keychain.get("token"),
              let realm = try? Realm(),
              let userId = realm.objects(UserDB.self).last?.id
        else { return }
        
        let parameters: [String: Any] =  [
            "userId": userId,
            "role": role
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        AF.request("https://foodrescue-api.onrender.com/users/addRole", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { [weak self] response in
            switch response.result {
                case .success(_):
                    self?.updateUserRole(role)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    private func updateUserRole(_ role: String) {
        do {
            let realm = try Realm()
            let user = realm.objects(UserDB.self).first
            
            realm.safeWrite {
                user?.role = Role(rawValue: role)
            }
        } catch {
            print(error)
        }
    }
}
