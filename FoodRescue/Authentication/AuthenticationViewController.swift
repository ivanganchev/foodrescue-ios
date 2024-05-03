//
//  AuthenticationViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2023-12-26.
//

import UIKit

class AuthenticationViewController: UIViewController {
    private var authenticationView: AuthenticationView!
    
    init(view: AuthenticationView) {
        super.init(nibName: nil, bundle: nil)
        
        self.authenticationView = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = authenticationView
    }
}
