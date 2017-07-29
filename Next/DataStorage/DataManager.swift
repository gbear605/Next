import Foundation
import UIKit
import CoreData

class DataManager: NSObject {
    
    static let singleton: DataManager = DataManager()
    
    let persistentContainer: NSPersistentContainer
    var managedContext: NSManagedObjectContext? = nil
    
    func loadData(for category: TodoModel.Category) {
        for todo in load(category) {
            TodoModel.singleton.add(todo: Todo(managedTodo: todo))
        }
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Next")
    }
    
    func load(_ category: TodoModel.Category) -> [TodoMO] {
        // We want to load all of the entitites that are todos.
        // Todo entities have a name structure that looks like GenericTodo or EventTodo
        let todoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "\("\(category)".capitalized)Todo")
        
        // We want to load them in display order
        todoFetch.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        
        // Then actually load all the todos as an array of managed todos.
        do {
            return try managedContext!.fetch(todoFetch) as! [TodoMO]
        } catch {
            fatalError("Failed to fetch \(category) todos: \(error)")
        }
    }
    
    func save() {
        do {
            try managedContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}
