//
//  ProfileViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-05.
//

import Foundation

class ProfileViewModel {
    private let userSessionService = UserSessionService()
    
    func logout() {
        userSessionService.logout()
    }
}
