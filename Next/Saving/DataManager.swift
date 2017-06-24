import Foundation
import UIKit
import CoreData

class DataManager: NSObject {
    
    let persistentContainer: NSPersistentContainer
    var managedContext: NSManagedObjectContext? = nil
    
    func convert(managedTodo: TodoMO) -> Todo {
        var category: TodoModel.Category? = nil
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
        
        return Todo (name: managedTodo.name!,
                     category: category!,
                     tags: [], //TODO: load tags
                     timeToDo: Time(amount: managedTodo.timeToDo, unit: Time.TimeUnit.MINUTE),
                     difficulty: Todo.TripleState(from: managedTodo.difficulty),
                     importance: Todo.TripleState(from: managedTodo.importance))
    }
    
    func loadData(for category: TodoModel.Category) {
        for todo in load(category) {
            print("Here6")
            // Save is false so that todos aren't lost
            // if the app crashes while this is happening
            TodoModel.add(category, todo: convert(managedTodo: todo), save: false)
        }
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Next")
    }
    
    func load(_ category: TodoModel.Category) -> [TodoMO]{
        let todoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "\("\(category)".capitalized)Todo")
        print("\(managedContext!.persistentStoreCoordinator)")
        do {
            return try managedContext!.fetch(todoFetch) as! [TodoMO]
        } catch {
            fatalError("Failed to fetch \(category) todos: \(error)")
        }
    }
    
    func makeManagedObject(from todo: Todo, category: TodoModel.Category) -> NSManagedObject {
        let managedTodo: TodoMO = NSEntityDescription.insertNewObject(forEntityName: "\("\(category)".capitalized)Todo", into: managedContext!) as! TodoMO
        managedTodo.name = todo.name
        managedTodo.timeToDo = todo.timeToDo.get(in: Time.TimeUnit.MINUTE)
        managedTodo.difficulty = todo.difficulty.toInt()
        managedTodo.importance = todo.importance.toInt()
        return managedTodo
        
        //TODO: Connect todo.tags
    }
    
    func save(todos: [TodoModel.Category:[Todo]]) {
        managedContext?.reset()
        for (category, specificTodos) in todos {
            for todo in specificTodos {
                let _ = makeManagedObject(from: todo, category: category)
            }
        }
        do {
            try managedContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}
