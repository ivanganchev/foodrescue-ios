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
        let latestSchemaVersion: UInt64 = 1
        let config = Realm.Configuration(schemaVersion: latestSchemaVersion,
                                         migrationBlock: {
            migration, version in
            // Still no migration code
        })
    }
}
