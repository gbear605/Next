//
//  Todo.swift
//  Next
//
//  Created by Garrison Taylor on 25-6-17.
//  Copyright © 2017 vivissi. All rights reserved.
//

import Foundation
import CoreData

class Todo {
    enum TripleState {
        case HIGH, MEDIUM, LOW, ERR
        
        func toInt() -> Int16 {
            switch self {
            case .HIGH:
                return 3
            case .MEDIUM:
                return 2
            case .LOW:
                return 1
            case .ERR:
                return 0
            }
        }
        
        init(from num: Int16) {
            switch num {
            case 3:
                self = .HIGH
            case 2:
                self = .MEDIUM
            case 1:
                self = .LOW
            default:
                self = .ERR
            }
        }
        
        init(from text: String) {
            switch text {
            case "HIGH":
                self = .HIGH
            case "MEDIUM":
                self = .MEDIUM
            case "LOW":
                self = .LOW
            default:
                self = .ERR
            }
        }
        
        init(from text: String?) {
            guard let text: String = text else {
                self = .ERR
                return
            }
            switch text {
            case "HIGH":
                self = .HIGH
            case "MEDIUM":
                self = .MEDIUM
            case "LOW":
                self = .LOW
            default:
                self = .ERR
            }
        }
    }
    
    private static func makeManagedObject(name: String, category: TodoModel.Category, tags: [TagMO], timeToDo: Time, difficulty: TripleState, importance: TripleState, displayOrder: Int32) -> TodoMO {
        let managedTodo: TodoMO = NSEntityDescription.insertNewObject(forEntityName: "\("\(category)".capitalized)Todo", into: DataManager.singleton.managedContext!) as! TodoMO
        managedTodo.name = name
        managedTodo.timeToDo = timeToDo.get(in: Time.TimeUnit.MINUTE)
        managedTodo.difficulty = difficulty.toInt()
        managedTodo.importance = importance.toInt()
        managedTodo.displayOrder = displayOrder
        managedTodo.addToTags(NSSet(array: tags))
        DataManager.singleton.save()
        return managedTodo
    }
    
    init(managedTodo: TodoMO) {
        self.managedTodo = managedTodo
        
        if managedTodo is GenericTodoMO {
            category = .GENERIC
        } else if managedTodo is DependentTodoMO {
            category = .DEPENDENT
        } else if managedTodo is EventTodoMO {
            category = .EVENT
        } else if managedTodo is LongtermTodoMO {
            category = .LONGTERM
        } else if managedTodo is NowTodoMO {
            category = .NOW
        } else {
            fatalError("Failed to convert managedTodo to specific category todo")
        }
        
        self.name = managedTodo.name!
        self.timeToDo = Time(amount: managedTodo.timeToDo, unit: Time.TimeUnit.MINUTE)
        self.difficulty = TripleState(from: managedTodo.difficulty)
        self.importance = TripleState(from: managedTodo.importance)
        self.tags = managedTodo.tags?.allObjects as! [TagMO]
        
    }
    
    init(name: String, category: TodoModel.Category, tags: [TagMO], timeToDo: Time, difficulty: TripleState, importance: TripleState, displayOrder: Int32) {
        self.name = name
        self.category = category
        self.tags = tags
        self.timeToDo = timeToDo
        self.difficulty = difficulty
        self.importance = importance
        self.managedTodo = Todo.makeManagedObject(name: name, category: category, tags: tags, timeToDo: timeToDo, difficulty: difficulty, importance: importance, displayOrder: displayOrder)
    }
    
    let name: String
    let category: TodoModel.Category
    let tags: [TagMO]
    let timeToDo: Time
    let difficulty: TripleState
    let importance: TripleState
    let managedTodo: TodoMO
    
    var displayOrder: Int {
        get {
            return Int(managedTodo.displayOrder)
        }
        
        set(x){
            managedTodo.displayOrder = Int32(x)
        }
    }
}
