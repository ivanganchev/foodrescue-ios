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
        loginView.confirmButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func presentSignUpController() {
        let signUpController = SignUpViewController()
        signUpController.modalPresentationStyle = .fullScreen
        self.present(signUpController, animated: false)
    }
    
    @objc func login() {
        guard let username = authenticationView.userNameField.text,
              let password = authenticationView.passwordField.text
        else { return }
        
        authenticationViewModel.login(username: username, password: password)
    }
    
    override func handleAuthentication(with result: Result<Void, Error>) {
        switch result {
            //TODO: make optional userId
        case .success(let userId):
            print("Successful Login!")
            
            let dashboardViewController = TabBarController()
            dashboardViewController.modalPresentationStyle = .fullScreen
            
            authenticationView.successCheckmarkView.show(completion: {
                self.present(dashboardViewController, animated: true, completion: nil)
            })
        case .failure(let error):
            print(error)
        }
    }
}
