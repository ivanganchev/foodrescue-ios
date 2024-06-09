//
//  UserDB.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-03.
//

import Foundation
import RealmSwift

class UserDB: Object {
    @Persisted var id: String?
    @Persisted var username: String?
    @Persisted var email: String?
    @Persisted var role: Role?
    
    convenience init(user: User) {
        self.init()
        
        self.id = UUID().uuidString.lowercased()
        self.username = user.username
        self.email = user.email
        self.role = user.role
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}
