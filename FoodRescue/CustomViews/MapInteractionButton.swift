//
//  MapInteractionButton.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-08-03.
//

import Foundation
import UIKit

class MapInteractionButton: UIButton {
    init(_ buttonType: UIButton.ButtonType = .custom,
         imageName: String?,
         text: String? = nil,
         fontSize: CGFloat? = nil,
         backgroundColor: UIColor? = nil,
         tintColor: UIColor? = nil, 
         cornerRadius: CGFloat? = nil) {
        super.init(frame: .zero)
        
        self.configure(imageName, text, fontSize, backgroundColor, tintColor, cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ imageName: String?,
                           _ text: String?,
                           _ fontSize: CGFloat?,
                           _ backgroundColor: UIColor?,
                           _ tintColor: UIColor?,
                           _ cornerRadius: CGFloat?) {
        if let imageName {
            let locationImage = UIImage(systemName: imageName)?.withTintColor(tintColor ?? .white, renderingMode: .alwaysOriginal)
            self.setImage(locationImage, for: .normal)
        }
        
        if let text {
            self.setTitle(text, for: .normal)
        }
        
        if let fontSize {
            self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        if let tintColor {
            self.tintColor = tintColor
        }
        
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        if let cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    func setButtonImage(name: String) {
        let locationImage = UIImage(systemName: name)
        self.setImage(locationImage, for: .normal)
    }
}
