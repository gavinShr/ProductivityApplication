//
//  ViewController.swift
//  ProductivityApplication
//
//  Created by Gavin Shrader on 8/27/19.
//  Copyright © 2019 Gavin Shrader. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var memory: MemoryManager!
    private var newTaskView: NewTaskButtonView!
    
    private var textField: UITextField!
    private var editID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCollectionView()
        memory = MemoryManager()
        loadNewTaskView()
    }
    
    private func loadNewTaskView() {
        newTaskView = NewTaskButtonView(frame: self.view.frame)
        newTaskView.delegate = self
        view.addSubview(newTaskView)
        NSLayoutConstraint.activate([
            newTaskView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newTaskView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newTaskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newTaskView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func loadCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        
        // Create Collection View
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register custom reusable cell class
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemoryManager.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Failed to dequeue reusable cell with identifier CustomCell.")
        }
        
        cell.updateTaskListID(indexPath.row)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editTask(indexPath.row)
    }
    
    private func editTask(_ ID: Int) {
        editID = ID
        
        var alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: handleClose))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!) {
        if let _ = textField, let ID = editID {
            self.textField = textField!
            self.textField.text = MemoryManager.tasks[ID].title
        }
    }
    
    func handleClose(alertView: UIAlertAction!) {
        let updatedText = (textField.text == nil) ? "New Task" : textField.text!
        
        var taskItem = MemoryManager.tasks[editID!]
        taskItem.title = updatedText
        
        MemoryManager.tasks.remove(at: editID!)
        MemoryManager.tasks.insert(taskItem, at: editID!)
        
        editID = nil
        textField = nil
        
        collectionView.reloadData()
        memory.saveData()
    }
    
}

extension ViewController: CustomCollectionViewCellDelegate {

    func updateMemory() {
        memory.saveData()
    }
    
    func deleteItem(_ ID: Int) {
        if MemoryManager.tasks.count > ID {
            MemoryManager.tasks.remove(at: ID)
            collectionView.reloadData()
            memory.saveData()
        }
    }
    
}

extension ViewController: NewTaskButtonViewDelegate {
    
    func addNewTask() {
        let newTask = TaskItem(isToggledOn: false, title: "New Task", notes: "")
        MemoryManager.tasks.insert(newTask, at: 0)
        collectionView.reloadData()
        memory.saveData()
        editTask(0)
    }
    
}

