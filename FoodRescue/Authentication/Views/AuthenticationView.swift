//
//  AuthenticationView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-03.
//

import UIKit

class AuthenticationView: UIView {
    let fieldsPadding = 40.0
    
    var authTypeLabel = UILabel()
    lazy var userNameField: UITextField = {
        let deviceBounds = UIScreen.main.bounds
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: deviceBounds.width - 30, height: 80))
        
        return field
    }()
    
    var passwordField = UITextField()
    var changeAuthTypeButton = UIButton()
    var confirmButton = UIButton()
    lazy var fieldsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var fieldsViewHeightConstraint: NSLayoutConstraint!
    var allFields: [UITextField] {
       [userNameField, passwordField]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(authTypeText: String, changeAuthTypeText: String) {
        setupBackground()
        setAuthTypeLabel(withText: authTypeText)
        setUserNameField()
        setPasswordField()
        setChangeAuthTypeButton(withText: changeAuthTypeText)
        setConfirmButton(withText: authTypeText)
    }
    
    func setAuthTypeLabel(withText text: String) {
        authTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        authTypeLabel.font = authTypeLabel.font.withSize(30)
        authTypeLabel.textColor = UIColor.black
        authTypeLabel.text = text
    }
    
    func setUserNameField() {
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.textColor = UIColor.mainGrey
        userNameField.leftViewMode = .always
        userNameField.layer.masksToBounds = true
        userNameField.addBottomBorder(withColor: UIColor.lightGray, andHeight: 1)
        userNameField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        userNameField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        
        let userNameImageView = UIImageView(image: UIImage(systemName: "person"))
        userNameImageView.tintColor = UIColor.mainGrey
        userNameField.leftView = userNameImageView
    }
    
    func setPasswordField() {
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.isSecureTextEntry = true
        passwordField.textColor = UIColor.mainGrey
        passwordField.leftViewMode = .always
        passwordField.layer.masksToBounds = true
        passwordField.addBottomBorder(withColor: UIColor.lightGray, andHeight: 1)
        passwordField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        let passwordImageView = UIImageView(image: UIImage(systemName: "lock"))
        passwordImageView.tintColor = UIColor.mainGrey
        passwordField.leftView = passwordImageView
    }
    
    func setChangeAuthTypeButton(withText text: String) {
        changeAuthTypeButton.translatesAutoresizingMaskIntoConstraints = false
        changeAuthTypeButton.setTitle(text, for: .normal)
        changeAuthTypeButton.setTitleColor(UIColor.lightGreen, for: .normal)
        changeAuthTypeButton.backgroundColor = .clear
        changeAuthTypeButton.layer.borderWidth = 0
    }
    
    func setConfirmButton(withText text: String) {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.cornerRadius = 5
        confirmButton.setTitle(text, for: .normal)
        
        disableConfirmButton(true)
    }
    
    func setConstraints() {
        self.addSubview(authTypeLabel)
        self.addSubview(fieldsView)
        self.fieldsView.addSubview(userNameField)
        self.fieldsView.addSubview(passwordField)
        self.addSubview(changeAuthTypeButton)
        self.addSubview(confirmButton)
        
        let guide = self.safeAreaLayoutGuide
        
        fieldsViewHeightConstraint = fieldsView.heightAnchor.constraint(equalToConstant: 115)
        
        NSLayoutConstraint.activate([
            userNameField.topAnchor.constraint(equalTo: fieldsView.topAnchor),
            userNameField.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor),
            userNameField.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor),
            userNameField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 15),
            passwordField.leadingAnchor.constraint(equalTo: fieldsView.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: fieldsView.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            changeAuthTypeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            changeAuthTypeButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
            
            authTypeLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 150),
            authTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            fieldsView.topAnchor.constraint(equalTo: authTypeLabel.bottomAnchor, constant: 20),
            fieldsView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            fieldsView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            fieldsViewHeightConstraint,
            
            confirmButton.topAnchor.constraint(equalTo: fieldsView.bottomAnchor, constant: 100),
            confirmButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            confirmButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
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
    
    func disableConfirmButton(_ disable: Bool) {
        confirmButton.isEnabled = disable ? false : true
        confirmButton.backgroundColor = disable ? .gray : UIColor.lightGreen
    }
}

extension AuthenticationView: UITextFieldDelegate {
    @objc func textChanged(_ textField: UITextField) {
        disableConfirmButton(allFields.contains(where: { $0.text!.isEmpty}))
    }
}
