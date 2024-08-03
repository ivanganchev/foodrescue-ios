//
//  MapInteractionButton.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-08-03.
//

import Foundation
import UIKit

class MapInteractionButton: UIButton {
    init(imageName: String) {
        super.init(frame: .zero)
        
        self.configure(imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ imageName: String) {
        let locationImage = UIImage(systemName: imageName)
        self.setImage(locationImage, for: .normal)
        self.tintColor = .mapButtonColor
        self.backgroundColor = .mainGrey
        self.layer.cornerRadius = 8.0
    }
    
    func setButtonImage(name: String) {
        let locationImage = UIImage(systemName: name)
        self.setImage(locationImage, for: .normal)
    }
}
