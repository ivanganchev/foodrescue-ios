//
//  RoleSelectionViewModel.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-06-09.
//

import Foundation

class RoleSelectionViewModel {
    let roleSelectionService = RoleSelectionService()
    
    var selectionResultHandler: ((Result<Void, Error>) -> Void)?
    
    func selectRole(role: Role) {
        roleSelectionService.selectRole(role: role.rawValue, completion: { result in
            guard let selectionResultHandler = self.selectionResultHandler else { return } 
            selectionResultHandler(result)
        })
    }
}
