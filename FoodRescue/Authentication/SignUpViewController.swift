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
        signUpView.confirmButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func presentLogInController() {
        self.dismiss(animated: false)
    }
    
    @objc func signUp() {
        guard let signUpView = authenticationView as? SignUpView,
              let username = signUpView.userNameField.text,
              let email = signUpView.emailField.text,
              let password = signUpView.passwordField.text
        else { return }
        
        authenticationViewModel.register(username: username, email: email, password: password)
    }
    
    override func handleAuthentication(with result: Result<Void, Error>) {
        switch result {
        case .success(let userId):
            print("Successful Sign Up!")
            
            let roleSelectionViewController = RoleSelectionViewController()
            roleSelectionViewController.modalPresentationStyle = .fullScreen
            
            authenticationView.successCheckmarkView.show(completion: {
                self.present(roleSelectionViewController, animated: true, completion: nil)
            })
        case .failure(let error):
            print(error)
        }
    }
}
