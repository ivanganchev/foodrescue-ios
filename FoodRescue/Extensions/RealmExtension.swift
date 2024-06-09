//
//  RealmExtension.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-04.
//

import Foundation
import RealmSwift

extension Realm {
    func safeWrite(wrappedFunction: () -> Void) {
        if isInWriteTransaction {
            wrappedFunction()
        } else {
            try? write {
                wrappedFunction()
            }
        }
    }
    
    static func deleteRealmObj(type: RealmSwift.Object.Type, primaryKey: String) {
        guard let realm = try? Realm(), let objToDelete = realm.object(ofType: type,
                                                                       forPrimaryKey: primaryKey) else { return }
        realm.safeWrite {
            realm.delete(objToDelete)
        }
    }
}
