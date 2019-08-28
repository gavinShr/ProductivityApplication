//
//  CustomCollectionViewCell.swift
//  ProductivityApplication
//
//  Created by Gavin Shrader on 8/27/19.
//  Copyright © 2019 Gavin Shrader. All rights reserved.
//

import UIKit

protocol CustomCollectionViewCellDelegate: class {
    func updateMemory()
    func deleteItem(_ ID: Int)
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    private var selectButton: UIButton!
    private var taskTitle: UILabel!
    private var selectView: UIView!
    private var checkmark: CAShapeLayer!
    private var deleteButton: UIButton!
    
    private var isToggledOn: Bool = false
    
    weak var delegate: CustomCollectionViewCellDelegate?
    
    var taskListID: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func updateTaskListID(_ ID: Int) {
        self.taskListID = ID
        let taskItem = MemoryManager.tasks[ID]
        isToggledOn = taskItem.isToggledOn
        taskTitle.text = taskItem.title
        
        updateUI(true)
    }
    
    private func sharedInit() {
        backgroundColor = .clear
        
        addSelectButton()
        addDeleteButton()
        addItemLabel()
        addCheckmark()
    }
    
    private func addDeleteButton() {
        // - create delete button
        deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.backgroundColor = UIColor.red
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.black.cgColor
        deleteButton.layer.cornerRadius = 6
        deleteButton.addTarget(self, action: #selector(deleteButtonPress), for: .touchUpInside)
        addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 18.5),
            deleteButton.heightAnchor.constraint(equalToConstant: 18.5),
            deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func deleteButtonPress() {
        HapticGenerator.applyHapticsFancy(.success)
        if let ID = taskListID {
            delegate?.deleteItem(ID)
        }
    }
    
    private func addSelectButton() {
        selectButton = UIButton()
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectButton)
        NSLayoutConstraint.activate([
            selectButton.widthAnchor.constraint(equalToConstant: frame.height),
            selectButton.heightAnchor.constraint(equalToConstant: frame.height),
            selectButton.leftAnchor.constraint(equalTo: leftAnchor),
            selectButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        // - add select view
        
        selectView = UIView()
        selectView.translatesAutoresizingMaskIntoConstraints = false
        selectView.isUserInteractionEnabled = false
        selectView.backgroundColor = .clear
        selectView.layer.borderWidth = 2
        selectView.layer.borderColor = UIColor.black.cgColor
        selectView.layer.cornerRadius = 6
        
        selectButton.addSubview(selectView)
        NSLayoutConstraint.activate([
            selectView.widthAnchor.constraint(equalToConstant: 18.5),
            selectView.heightAnchor.constraint(equalToConstant: 18.5),
            selectView.centerXAnchor.constraint(equalTo: selectButton.centerXAnchor),
            selectView.centerYAnchor.constraint(equalTo: selectButton.centerYAnchor)
            ])
        
        // - add button response
        
        selectButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
    }
    
    private func addCheckmark() {
        checkmark = CAShapeLayer()
        checkmark.strokeColor = UIColor.black.cgColor
        checkmark.fillColor = UIColor.clear.cgColor
        checkmark.strokeEnd = 0
        checkmark.lineWidth = 2
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 4, y: 9.5))
        path.addLine(to: CGPoint(x: 8.35, y: 13.75))
        path.move(to: CGPoint(x: 7.61, y: 13.37))
        path.addLine(to: CGPoint(x: 14.3, y: 5.5))
        
        checkmark.path = path
        checkmark.position = selectView.center
        selectView.layer.addSublayer(checkmark)
    }
    
    private func addItemLabel() {
        taskTitle = UILabel()
        taskTitle.translatesAutoresizingMaskIntoConstraints = false
        taskTitle.textAlignment = .left
        taskTitle.textColor = UIColor.black
        taskTitle.text = ""
        taskTitle.font = UIFont.systemFont(ofSize: 20)
        
        addSubview(taskTitle)
        NSLayoutConstraint.activate([
            taskTitle.leftAnchor.constraint(equalTo: selectButton.rightAnchor, constant: 5),
            taskTitle.rightAnchor.constraint(equalTo: deleteButton.rightAnchor, constant: -5),
            taskTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    // - button response
    
    @objc private func selectButtonPressed() {
        isToggledOn = !isToggledOn
        updateUI(false)
        updateItemInMemory()
        delegate?.updateMemory()
        HapticGenerator.applyHaptics()
    }
    
    private func updateUI(_ isFast: Bool) {
        if isFast {
            CATransaction.setDisableActions(true)
            checkmark.strokeEnd = isToggledOn ? 1 : 0
            CATransaction.commit()
            selectView.backgroundColor = isToggledOn ? UIColor.blue.withAlphaComponent(0.5) : UIColor.clear
            taskTitle.alpha = isToggledOn ? 0.5 : 1
        } else {
            UIView.animate(withDuration: 0.65, animations: {
                self.checkmark.strokeEnd = self.isToggledOn ? 1 : 0
                self.selectView.backgroundColor = self.isToggledOn ? UIColor.blue.withAlphaComponent(0.5) : UIColor.clear
                self.taskTitle.alpha = self.isToggledOn ? 0.5 : 1
            })
        }
    }
    
    private func updateItemInMemory() {
        if let ID = taskListID {
            var taskItem = MemoryManager.tasks[ID]
            taskItem.isToggledOn = isToggledOn
            MemoryManager.tasks[ID] = taskItem
        }
    }
    
}


