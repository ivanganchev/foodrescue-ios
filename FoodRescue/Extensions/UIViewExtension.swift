//
//  UIViewExtension.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-01-06.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addBottomArc(ofHeight height: CGFloat, topCornerRadius: CGFloat) {
       let arcBezierPath = UIBezierPath()
       arcBezierPath.move(to: CGPoint(x: 0, y: frame.height))
       arcBezierPath.addQuadCurve(to: CGPoint(x: frame.width, y: frame.height), controlPoint: CGPoint(x: frame.width / 2 , y: frame.height + height))
       arcBezierPath.close()

       let shapeLayer = CAShapeLayer()

       shapeLayer.path = arcBezierPath.cgPath
       shapeLayer.fillColor = UIColor.white.cgColor

       layer.insertSublayer(shapeLayer, at: 0)
       layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       layer.cornerRadius = topCornerRadius
    }
    
    func roundCorners() {
        let y = bounds.size.height - 80.0

        let p1 = CGPoint(x: 0.0, y: y)
        let p2 = CGPoint(x: bounds.size.width, y: y)

        let cp1 = CGPoint(x: p1.x, y: bounds.size.height)
        let cp2 = CGPoint(x: bounds.size.width, y: bounds.size.height)

        let myBez = UIBezierPath()

        myBez.move(to: CGPoint(x: 0.0, y: y))

        myBez.addCurve(to: p2, controlPoint1: cp1, controlPoint2: cp2)

        myBez.addLine(to: CGPoint(x: bounds.size.width, y: 0.0))
        myBez.addLine(to: CGPoint.zero)

        myBez.close()

        let l = CAShapeLayer()
        l.path = myBez.cgPath
        layer.mask = l
    }
}
