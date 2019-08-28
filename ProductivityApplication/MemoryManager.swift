//
//  MemoryManager.swift
//  ProductivityApplication
//
//  Created by Gavin Shrader on 8/27/19.
//  Copyright © 2019 Gavin Shrader. All rights reserved.
//

import Foundation

// - represents a single Task which will be displayed via an instance of CustomCollectionViewCell
struct TaskItem: Codable {
    var isToggledOn: Bool
    var title: String
    var notes: String
}

// - handles on-device memory retrieval and storage
class MemoryManager {
    
    static var tasks: [TaskItem]! 
    private let defaults = UserDefaults.standard
    private let DEFAULTS_KEY = "TASK_LIST"
    
    init() {
        MemoryManager.tasks = [TaskItem]()
        retrieveData()
        saveData()
    }

    private func retrieveData() {
        var didFail = false
        if let data = UserDefaults.standard.value(forKey: DEFAULTS_KEY) as? Data {
            if let tasks = try? PropertyListDecoder().decode(Array<TaskItem>.self, from: data) {
                MemoryManager.tasks = tasks
            } else { didFail = true }
        } else { didFail = true }
        
        guard didFail else { return }
        
        MemoryManager.tasks = [
            TaskItem(isToggledOn: false, title: "task 1", notes: "this is task 1"),
            TaskItem(isToggledOn: false, title: "task 2", notes: "this is task 2"),
            TaskItem(isToggledOn: true, title: "task 3", notes: "this is task 3"),
            TaskItem(isToggledOn: false, title: "task 4", notes: "this is task 4"),
            TaskItem(isToggledOn: false, title: "task 5", notes: "this is task 5"),
            TaskItem(isToggledOn: true, title: "task 6", notes: "this is task 6")
        ]
    }
    
    func saveData() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(MemoryManager.tasks), forKey: DEFAULTS_KEY)
    }
    
}
