//
//  RoleSelectionView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-05-25.
//

import UIKit

class RoleSelectionView: UIView {
    let selectRoleTitle = UILabel()
    let customerRoleView = RoleView(roleTitleText: "Customer",
                                    roleDescriptionText: "Choose from different variations of restaurants and buy hugely discounted food",
                                    roleIconImage: UIImage(systemName: "takeoutbag.and.cup.and.straw.fill") ?? UIImage(), 
                                    roleType: .customer)
    
    let ownerRoleView = RoleView(roleTitleText: "Owner",
                                 roleDescriptionText: "Be able to add your own restaurant and sell food for the community!",
                                 roleIconImage: UIImage(systemName: "fork.knife.circle") ?? UIImage(),
                                 roleType: .owner)
    
    let confirmButton = UIButton()
    
    var currentlySelectedRole: Role?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        customerRoleView.translatesAutoresizingMaskIntoConstraints = false
        ownerRoleView.translatesAutoresizingMaskIntoConstraints = false
        
        setSelectRoleTitle()
        setConfirmButton()
        setupConstraints()
        
        customerRoleView.delegate = self
        ownerRoleView.delegate = self
    }
    
    private func setSelectRoleTitle() {
        selectRoleTitle.translatesAutoresizingMaskIntoConstraints = false
        selectRoleTitle.text = "Select a Role."
        selectRoleTitle.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func setConfirmButton() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.cornerRadius = 5
        confirmButton.setTitle("Confirm", for: .normal)
        
        disableConfirmButton(true)
    }
    
    private func setupConstraints() {
        self.addSubview(selectRoleTitle)
        self.addSubview(customerRoleView)
        self.addSubview(ownerRoleView)
        self.addSubview(confirmButton)
        
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            selectRoleTitle.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            selectRoleTitle.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            customerRoleView.topAnchor.constraint(equalTo: selectRoleTitle.bottomAnchor, constant: 40),
            customerRoleView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            customerRoleView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            customerRoleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18),
            
            ownerRoleView.topAnchor.constraint(equalTo: customerRoleView.bottomAnchor, constant: 20),
            ownerRoleView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            ownerRoleView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            ownerRoleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18),
            
            confirmButton.topAnchor.constraint(equalTo: ownerRoleView.bottomAnchor, constant: 50),
            confirmButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 30),
            confirmButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func disableConfirmButton(_ disable: Bool) {
        confirmButton.isEnabled = disable ? false : true
        confirmButton.backgroundColor = disable ? .gray : UIColor.lightGreen
    }
}

extension RoleSelectionView: RoleViewTapDelegate {
    func handleTap(_ roleType: Role) {
        disableConfirmButton(false)
        customerRoleView.setSelectedStyle(roleType == .customer ? true : false)
        ownerRoleView.setSelectedStyle(roleType == .owner ? true : false)
        currentlySelectedRole = roleType
    }
}
