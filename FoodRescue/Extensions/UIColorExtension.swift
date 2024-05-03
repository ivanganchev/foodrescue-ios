//
//  UIColorExtension.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-06.
//

import UIKit

extension UIColor {
    static let mainGreen = UIColor(red: 76, green: 145, blue: 115)
    static let lightGreen = UIColor(red: 125, green: 216, blue: 125)
    static let mainGrey = UIColor(red: 105, green: 105, blue: 105)
    static let fadedGrey = UIColor(red: 155, green: 155, blue: 155)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
