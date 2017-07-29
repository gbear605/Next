import Foundation

class TodoModel {
    
    static let singleton: TodoModel = TodoModel()
    
    enum Category {
        case GENERIC, DEPENDENT, NOW, LONGTERM, EVENT
        
        static let list: [Category] = [.GENERIC, .DEPENDENT, .NOW, .LONGTERM, .EVENT]
    }
    
    private var todos: [Category:[Todo]] = [.GENERIC:[], .DEPENDENT:[], .NOW:[], .LONGTERM:[], .EVENT:[]]
    
    func add(todo toAdd: Todo, at index: Int = -1) {
        if index == -1 {
            toAdd.displayOrder = numTodos(category: toAdd.category)
            todos[toAdd.category]!.append(toAdd)
        } else {
            todos[toAdd.category]!.append(toAdd)
            move(toAdd.category, from: numTodos(category: toAdd.category) - 1, to: index)
        }
        DataManager.singleton.save()
    }
    
    func move(_ category: Category, from indexFrom: Int, to indexTo: Int) {
        if indexFrom == indexTo {
            todos[category]![indexTo].displayOrder = indexTo
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
    
    func numTodos(category: Category) -> Int {
        return todos[category]!.count
    }
    
    func get(_ category: Category, from index: Int) -> Todo {
        return todos[category]![index]
    }
    
    func get(_ category: Category) -> [Todo] {
        return todos[category]!
    }
    
    func delete(_ category: Category, at index: Int) {
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
