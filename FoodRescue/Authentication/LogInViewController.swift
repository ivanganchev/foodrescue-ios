//
//  LogInViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-03.
//

import UIKit

class LogInViewController: AuthenticationViewController {
    init() {
        let loginView = LoginView()
        super.init(view: loginView)
        
        loginView.setUpViews(authTypeText: "Log in", changeAuthTypeText: "Sign Up")
        loginView.setConstraints()
        
        loginView.changeAuthTypeButton.addTarget(self, action: #selector(presentSignUpController), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func presentSignUpController() {
        let signUpController = SignUpViewController()
        signUpController.modalPresentationStyle = .fullScreen
        self.present(signUpController, animated: false)
    }
}
