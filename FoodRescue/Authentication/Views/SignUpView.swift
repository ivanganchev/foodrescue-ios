//
//  SignUpView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-03.
//

import UIKit

class SignUpView: AuthenticationView {
    var emailField = UITextField()
    override var successText: String {
        return "Sign up Successful"
    }
    
    override var allFields: [UITextField] {
       [userNameField, passwordField, emailField]
    }
    
    override func setUpViews(authTypeText: String, changeAuthTypeText: String) {
        super.setUpViews(authTypeText: authTypeText, changeAuthTypeText: changeAuthTypeText)
        
        setEmailField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        emailField.addBottomBorder(withColor: UIColor.lightGray, andHeight: 1)
    }
    
    func setEmailField() {
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.textColor = UIColor.mainGrey
        emailField.leftViewMode = .always
        emailField.layer.masksToBounds = true
        emailField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        emailField.isUserInteractionEnabled = true
        
        
        let emailFieldImageView = UIImageView(image: UIImage(systemName: "envelope"))
        emailFieldImageView.tintColor = UIColor.mainGrey
        emailField.leftView = emailFieldImageView
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        self.fieldsView.addSubview(emailField)
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 15),
            emailField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            emailField.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        fieldsViewHeightConstraint.constant = 180
    }
}
