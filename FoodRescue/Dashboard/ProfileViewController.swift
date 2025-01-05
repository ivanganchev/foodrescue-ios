//
//  ProfileViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-05.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    let profileViewModel = ProfileViewModel()
    let successCheckmarkView = SuccessCheckmarkView(message: "Logged out")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileView = UIHostingController(rootView: ProfileView(logoutAction: {
            self.profileViewModel.logout()
            self.showLogin()
        }))
        
        successCheckmarkView.translatesAutoresizingMaskIntoConstraints = false
                
        addChild(profileView)
        view.addSubview(profileView.view)
        view.addSubview(successCheckmarkView)
        
        profileView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.view.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            successCheckmarkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successCheckmarkView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        profileView.didMove(toParent: self)
    }
    
    private func showLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else { return }
        
        self.successCheckmarkView.show {
            let loginViewController = LogInViewController()
            window.rootViewController = loginViewController
            window.makeKeyAndVisible()
        }
    }
}
