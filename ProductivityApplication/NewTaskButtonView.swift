//
//  NewTaskButton.swift
//  ProductivityApplication
//
//  Created by Gavin Shrader on 8/27/19.
//  Copyright © 2019 Gavin Shrader. All rights reserved.
//

import UIKit

protocol NewTaskButtonViewDelegate: class {
    func addNewTask()
}

class NewTaskButtonView: UIView {
    
    private let buttonSize: CGFloat = 50
    private var plusButton: UIButton!
    private var plus: CAShapeLayer!
    
    weak var delegate: NewTaskButtonViewDelegate?
    
    // - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton()
        addPlusLayer()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported!")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if plusButton.frame.contains(point) {
            return true
        } else {
            return false
        }
    }
    
    private func addButton() {
        plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.backgroundColor = UIColor.blue
        plusButton.layer.cornerRadius = buttonSize / 2
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        
        addSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: buttonSize),
            plusButton.heightAnchor.constraint(equalToConstant: buttonSize),
            plusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func addPlusLayer() {
        plus = CAShapeLayer()
        plus.strokeColor = UIColor.white.cgColor
        plus.fillColor = UIColor.clear.cgColor
        plus.strokeEnd = 1
        plus.lineWidth = 2
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: buttonSize / 2, y: 12))
        path.addLine(to: CGPoint(x: buttonSize / 2, y: buttonSize - 12))
        path.move(to: CGPoint(x: buttonSize / 2, y: buttonSize / 2))
        path.addLine(to: CGPoint(x: 12, y: buttonSize / 2))
        path.addLine(to: CGPoint(x: buttonSize - 12, y: buttonSize / 2))
        
        plus.path = path
        plus.position = plusButton.center
        plusButton.layer.addSublayer(plus)
    }
    
    // - button response
    
    @objc private func plusButtonPressed() {
        HapticGenerator.applyHaptics()
        delegate?.addNewTask()
    }
    
}
