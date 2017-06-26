import Foundation
import UIKit
import CoreData

class DataManager: NSObject {
    
    static let singleton: DataManager = DataManager()
    
    let persistentContainer: NSPersistentContainer
    var managedContext: NSManagedObjectContext? = nil
    
    func loadData(for category: TodoModel.Category) {
        for todo in load(category) {
            // Save is false so that todos aren't lost
            // if the app crashes while this is happening
            TodoModel.add(category, todo: Todo(managedTodo: todo))
        }
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Next")
    }
    
    func load(_ category: TodoModel.Category) -> [TodoMO]{
        let todoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "\("\(category)".capitalized)Todo")
        if todoFetch.sortDescriptors == nil {
            todoFetch.sortDescriptors = []
        }
        todoFetch.sortDescriptors!.append(NSSortDescriptor(key: "displayOrder", ascending: true))
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
