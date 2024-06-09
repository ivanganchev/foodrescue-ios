//
//  JWTAuthentication.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2023-12-26.
//

import Foundation
import JWTDecode
import KeychainSwift

class JWTAuthentication {
    let keychain = KeychainSwift()
    
    func storeJWToken(_ jwt: String) {
        keychain.set(jwt, forKey: "token")
        print("Successfully saved token")
    }
    
    func getDecodedUserId() -> String? {
        let jwt = keychain.get("token")
        
        guard let jwt = jwt,
              let decodedToken = try? decode(jwt: jwt) else {
            return nil
        }
        
        return decodedToken.body["id"] as? String
    }
}
