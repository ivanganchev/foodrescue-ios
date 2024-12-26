//
//  UserSessionService.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-25.
//

import Foundation
import RealmSwift

class UserSessionService {
    func getUserId() -> String {
        do {
            let realm = try Realm()
            let user = realm.objects(UserDB.self).first
            
            return user?.id ?? ""
        } catch {
            print(error)
            return ""
        }
    }
}
