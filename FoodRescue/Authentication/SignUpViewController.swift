//
//  SignUpViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-03.
//

import UIKit

class SignUpViewController: AuthenticationViewController {    
    init() {
        let signUpView = SignUpView()
        super.init(view: signUpView)
        
        signUpView.setUpViews(authTypeText: "Sign Up", changeAuthTypeText: "Log in")
        signUpView.setConstraints()
        
        signUpView.changeAuthTypeButton.addTarget(self, action: #selector(presentLogInController), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func presentLogInController() {
        self.dismiss(animated: false)
    }
}
