import Foundation

class TodoModel {
    
    enum Category {
        case GENERIC, DEPENDENT, NOW, LONGTERM, EVENT
        
        static let list: [Category] = [.GENERIC, .DEPENDENT, .NOW, .LONGTERM, .EVENT]
    }
    
    private static var todos: [Category:[Todo]] = [.GENERIC:[], .DEPENDENT:[], .NOW:[], .LONGTERM:[], .EVENT:[]]
    
    static func add(_ category: Category, todo toAdd: Todo, at index: Int = -1) {
        if index == -1 {
            toAdd.displayOrder = numTodos(category: category)
            todos[category]!.append(toAdd)
        } else {
            todos[category]!.append(toAdd)
            move(category, from: numTodos(category: category) - 1, to: index)
        }
        DataManager.singleton.save()
    }
    
    static func move(_ category: Category, from indexFrom: Int, to indexTo: Int) {
        if indexFrom == indexTo {
            return
        }
        for todo in todos[category]! {
            if indexFrom < indexTo {
                if todo.displayOrder > indexFrom && todo.displayOrder <= indexTo {
                    todo.displayOrder = todo.displayOrder - 1
                }
            } else {
                if todo.displayOrder < indexFrom && todo.displayOrder >= indexTo {
                    todo.displayOrder = todo.displayOrder + 1
                }
            }
        }
        let todo: Todo = todos[category]!.remove(at: indexFrom)
        todos[category]!.insert(todo, at: indexTo)
        todo.displayOrder = indexTo
        DataManager.singleton.save()
    }
    
    static func numTodos(category: Category) -> Int {
        return todos[category]!.count
    }
    
    static func get(_ category: Category, from index: Int) -> Todo {
        return todos[category]![index]
    }
    
    static func delete(_ category: Category, at index: Int) {
        for todo in todos[category]! {
            if todo.displayOrder > index {
                todo.displayOrder = todo.displayOrder - 1
            }
        }
        let todo: Todo = todos[category]!.remove(at: index)
        DataManager.singleton.managedContext!.delete(todo.managedTodo)
        DataManager.singleton.save()
    }
    
}
