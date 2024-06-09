//
//  RoleView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-25.
//

import UIKit

protocol RoleViewTapDelegate: AnyObject {
    func handleTap(_ roleType: RoleType)
}

enum RoleType {
    case customer
    case owner
}

class RoleView: UIView {
    private var roleTitle = UILabel()
    private var roleDescription = UILabel()
    private var roleIcon = UIImageView()
    weak var delegate: RoleViewTapDelegate?
    private var roleType: RoleType
    
    init(roleTitleText: String, roleDescriptionText: String, roleIconImage: UIImage, roleType: RoleType) {
        self.roleType = roleType
        super.init(frame: .zero)
        
        setupParentView()
        setupRoleTitle(with: roleTitleText)
        setupRoleDescription(with: roleDescriptionText)
        setupRoleIcon(with: roleIconImage)
        
        
        setConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupParentView() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
    }
    
    private func setupRoleTitle(with roleTitleText: String) {
        roleTitle.translatesAutoresizingMaskIntoConstraints = false
        roleTitle.font = UIFont.boldSystemFont(ofSize: 17)
        roleTitle.textColor = UIColor.black
        roleTitle.text = roleTitleText
    }
    
    private func setupRoleDescription(with roleDescriptionText: String) {
        roleDescription.translatesAutoresizingMaskIntoConstraints = false
        roleDescription.textColor = UIColor.mainGrey
        roleDescription.text = roleDescriptionText
        roleDescription.numberOfLines = 0
    }
    
    private func setupRoleIcon(with roleIconImage: UIImage) {
        roleIcon.translatesAutoresizingMaskIntoConstraints = false
        
        roleIcon.image = roleIconImage
        setRoleIconConfiguration(false)
    }
    
    private func setRoleIconConfiguration(_ isSelected: Bool) {
        let paletterColors = isSelected ? [UIColor.mainGreen, UIColor.mainGreen] : [UIColor.mainGreen, UIColor.black]
        
        let config = UIImage.SymbolConfiguration(paletteColors: paletterColors)
        let customImage = roleIcon.image?.applyingSymbolConfiguration(config)
        roleIcon.image = customImage
    }
    
    private func setConstraints() {
        self.addSubview(roleTitle)
        self.addSubview(roleDescription)
        self.addSubview(roleIcon)
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            roleIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            roleIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            roleIcon.heightAnchor.constraint(equalToConstant: 50),
            roleIcon.widthAnchor.constraint(equalToConstant: 50),
            
            roleTitle.topAnchor.constraint(equalTo: roleIcon.bottomAnchor, constant: 8),
            roleTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            roleDescription.topAnchor.constraint(equalTo: roleTitle.bottomAnchor, constant: 10),
            roleDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            roleDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)
        ])
    }
    
    func setSelectedStyle(_ isSelected: Bool) {
        self.layer.borderColor = isSelected ? UIColor.mainGreen.cgColor : UIColor.black.cgColor
        self.roleTitle.textColor =  isSelected ? UIColor.mainGreen : UIColor.black
        setRoleIconConfiguration(isSelected)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.handleTap(roleType)
    }
}
