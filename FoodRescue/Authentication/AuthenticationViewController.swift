//
//  AuthenticationViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2023-12-26.
//

import UIKit

class AuthenticationViewController: UIViewController {
    let authenticationView = AuthenticationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = authenticationView
    }
}
