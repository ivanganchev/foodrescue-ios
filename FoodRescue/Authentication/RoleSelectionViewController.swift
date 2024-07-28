//
//  RoleSelectionViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-25.
//

import UIKit

class RoleSelectionViewController: UIViewController {
    let roleSelectionView = RoleSelectionView()
    var roleSelectionViewModel: RoleSelectionViewModel {
        let roleSelectionViewModel = RoleSelectionViewModel()
        roleSelectionViewModel.selectionResultHandler = handleRoleSelection
        
        return roleSelectionViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.roleSelectionView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        self.view = roleSelectionView
    }
    
    @objc func confirmButtonTapped() {
        guard let selectedRole = roleSelectionView.currentlySelectedRole else { return }
        roleSelectionViewModel.selectRole(role: selectedRole)
    }
    
    func handleRoleSelection(with result: Result<Void, Error>) {
        switch result {
        case .success():
            print("Successful Role selected!")
            
            let dashboardViewController = TabBarController()
            dashboardViewController.modalPresentationStyle = .fullScreen

            self.present(dashboardViewController, animated: true, completion: nil)
        case .failure(let error):
            print(error)
        }
    }
}
