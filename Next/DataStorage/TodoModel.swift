import Foundation

class TodoModel {
    
    enum Category {
        case GENERIC, DEPENDENT, NOW, LONGTERM, EVENT
        
        static let list: [Category] = [.GENERIC, .DEPENDENT, .NOW, .LONGTERM, .EVENT]
    }
    
    static var todos: [Category:[Todo]] = [.GENERIC:[], .DEPENDENT:[], .NOW:[], .LONGTERM:[], .EVENT:[]]
    
    static func add(_ category: Category, todo toAdd: Todo, at index: Int = -1) {
        if index == -1 {
            todos[category]!.append(toAdd)
        } else {
            todos[category]!.insert(toAdd, at: index)
        }
    }
    
    static func move(_ category: Category, from indexFrom: Int, to indexTo: Int) {
        let todo: Todo = todos[category]!.remove(at: indexFrom)
        todos[category]!.insert(todo, at: indexTo)
    }
    
    static func numTodos(category: Category) -> Int {
        return todos[category]!.count
    }
    
    static func get(_ category: Category, from index: Int) -> Todo {
        return todos[category]![index]
    }
    
    static func delete(_ category: Category, at index: Int) {
        let todo: Todo = todos[category]!.remove(at: index)
        DataManager.singleton.managedContext!.delete(todo.managedTodo)
        DataManager.singleton.save()
    }
    
}
