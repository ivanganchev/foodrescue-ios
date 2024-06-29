//
//  SuccessCheckmarkView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-06-15.
//

import Foundation
import UIKit

class SuccessCheckmarkView: UIView {
    private var messageView: UIView
    private var messageLabel: UILabel
    
    init(message: String) {
        messageView = UIView(frame: .zero)
        messageLabel = UILabel(frame: .zero)
        
        super.init(frame: .zero)
        
        self.setMessageView()
        self.setMessageLabel(with: message)
        self.setConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMessageView() {
        messageView.backgroundColor = .mainGrey
        messageView.layer.cornerRadius = 10
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.alpha = 0
    }
    
    private func setMessageLabel(with message: String) {
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(messageLabel)
    }
    
    private func setConstraints() {
        self.addSubview(messageView)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8),
            messageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageView.widthAnchor.constraint(equalToConstant: 180),
            messageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func show(completion: @escaping () -> ()) {
        self.addCheckmarkAnimationToView(view: messageView)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.messageView.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                self.messageView.alpha = 0
            }) { (finished) in
                completion()
            }
        }
    }
    
    private func addCheckmarkAnimationToView(view: UIView) {
            let checkmarkLayer = CAShapeLayer()
            checkmarkLayer.strokeColor = UIColor(red: 52/255.0, green: 199/255.0, blue: 89/255.0, alpha: 1.0).cgColor
            checkmarkLayer.fillColor = UIColor.clear.cgColor
            checkmarkLayer.lineWidth = 8.0
            checkmarkLayer.lineCap = .round
            checkmarkLayer.lineJoin = .round
            
            let size: CGFloat = 150.0
            let checkmarkPath = UIBezierPath()
            checkmarkPath.move(to: CGPoint(x: size * 0.2, y: size * 0.5))
            checkmarkPath.addLine(to: CGPoint(x: size * 0.4, y: size * 0.7))
            checkmarkPath.addLine(to: CGPoint(x: size * 0.8, y: size * 0.3))
            
            checkmarkLayer.path = checkmarkPath.cgPath
            checkmarkLayer.position = CGPoint(x: view.bounds.midX - size / 2, y: view.bounds.midY - size / 2 - 25)
            
            view.layer.addSublayer(checkmarkLayer)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 0.5
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            checkmarkLayer.add(animation, forKey: "checkmarkAnimation")
        }
}
