//
//  AuthenticationViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2023-12-26.
//

import UIKit

class AuthenticationViewController: UIViewController {
    var authenticationView: AuthenticationView!
    var authenticationViewModel: AuthenticationViewModel {
        let authenticationViewModel = AuthenticationViewModel()
        authenticationViewModel.authenticationResultHandler = handleAuthentication
        
        return authenticationViewModel
    }
    
    init(view: AuthenticationView) {
        super.init(nibName: nil, bundle: nil)
        
        self.authenticationView = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func loadView() {
        self.view = authenticationView
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func handleAuthentication(with result: Result<Void, Error>) {}
}
