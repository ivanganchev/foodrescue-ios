//
//  AuthenticationViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-03.
//

import Foundation

class AuthenticationViewModel {
    let authService = AuthenticationService()
    
    var authenticationResultHandler: ((Result<Void, Error>) -> Void)?
    
    func login(username: String, password: String) {
        authService.login(username: username, password: password, completion: { result in
            guard let authenticationResultHandler = self.authenticationResultHandler else { return }
            authenticationResultHandler(result)
        })
    }
    
    func register(username: String, email: String, password: String) {
        authService.register(username: username, email: email, password: password, completion: { result in
            guard let authenticationResultHandler = self.authenticationResultHandler else { return }
            authenticationResultHandler(result)
        })
    }
}
