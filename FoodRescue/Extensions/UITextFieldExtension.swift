//
//  UITextFieldExtension.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-06.
//

import UIKit

extension UITextField {
    enum PaddingSpace {
        case left(CGFloat)
        case right(CGFloat)
        case equalSpacing(CGFloat)
    }
    
    func addPadding(padding: PaddingSpace) {
        self.leftViewMode = .always
        self.layer.masksToBounds = true

        switch padding {

        case .left(let spacing):
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always

        case .right(let spacing):
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always

        case .equalSpacing(let spacing):
            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            
            self.leftView = equalPaddingView
            self.leftViewMode = .always
            
            self.rightView = equalPaddingView
            self.rightViewMode = .always
        }
    }
    
    func addBottomBorder(withColor color: UIColor = .black, andHeight height: CGFloat = 1.0) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: 50 - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
