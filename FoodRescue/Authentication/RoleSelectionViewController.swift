//
//  RoleSelectionViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-25.
//

import UIKit

class RoleSelectionViewController: UIViewController {
    let roleSelectionView = RoleSelectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.roleSelectionView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        self.view = roleSelectionView
    }
    
    @objc func confirmButtonTapped() {
        // Switch to next view - either Owner or Customer
    }
}
