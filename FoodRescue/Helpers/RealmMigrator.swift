//
//  RealmMigrator.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-12.
//

import Foundation
import RealmSwift

class RealmMigrator {
    static func migrateRealm() {
        let latestSchemaVersion: UInt64 = 3
        
        let config = Realm.Configuration(schemaVersion: latestSchemaVersion,
                                         migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 3 {
                //Map the old 'reservationExpiration' to the new 'reservationExpiresAt'
                migration.enumerateObjects(ofType: "MealDB") { oldObject, newObject in
                    if let oldExpiration = oldObject?["reservationExpiration"] as? Date {
                        newObject?["reservationExpiresAt"] = oldExpiration
                    }
                    
                    newObject?["reserved"] = false
                }
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
}
