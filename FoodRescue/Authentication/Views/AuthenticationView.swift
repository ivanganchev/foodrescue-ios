//
//  AuthenticationView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-03.
//

import UIKit

class AuthenticationView: UIView {
    var authTypeLabel = UILabel()
    var userNameField = UITextField()
    var passwordField = UITextField()
    var changeAuthTypeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        setupBackground()
        
        authTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        authTypeLabel.font = authTypeLabel.font.withSize(30)
        
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.textColor = .white
        userNameField.addBottomBorder(withColor: UIColor.mainGrey, andHeight: 1)
        userNameField.addPadding(padding: .left(20))
        userNameField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        changeAuthTypeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        self.addSubview(authTypeLabel)
        self.addSubview(userNameField)
        self.addSubview(passwordField)
        self.addSubview(changeAuthTypeButton)
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            authTypeLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            authTypeLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            authTypeLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 10),
            
            userNameField.topAnchor.constraint(equalTo: authTypeLabel.bottomAnchor, constant: 20),
            userNameField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            userNameField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupBackground() {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.mainGreen
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)
        
        let upperView = UIView()
        upperView.backgroundColor = .white
        upperView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(upperView)
        
        upperView.layer.cornerRadius = 80
        upperView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        upperView.layer.shadowRadius = 2
        upperView.layer.shadowColor = UIColor.black.cgColor
        upperView.layer.shadowOffset = CGSize(width: 1, height: 5)
        upperView.layer.shadowOpacity = 0.25
        
        let deviceBounds = UIScreen.main.bounds
        
        NSLayoutConstraint.activate([
            upperView.topAnchor.constraint(equalTo: topAnchor),
            upperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            upperView.heightAnchor.constraint(equalToConstant: deviceBounds.height * 0.9),
            
            bottomView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: -100),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
