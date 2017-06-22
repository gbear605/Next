import Foundation

class TodoModel {
    
    static var genericTodos: [Todo] = []
    
    static func addGeneric(todo toAdd: Todo, at index: Int, save: Bool = true) {
        genericTodos.insert(toAdd, at: index)
        if save {
            saveTodos()
        }
    }
    
    static func addGeneric(todo toAdd: Todo, save: Bool = true) {
        genericTodos.append(toAdd)
        if save {
            saveTodos()
        }
    }
    
    static func numGenericTodos() -> Int {
        return genericTodos.count
    }
    
    static func getGeneric(from index: Int) -> Todo {
        return genericTodos[index]
    }
    
    static func removeGeneric(at index: Int, save: Bool = true) {
        genericTodos.remove(at: index)
        if save {
            saveTodos()
        }
    }
    
    static private func saveTodos() {
        AppDelegate.dataManager?.save(todos: genericTodos)
    }
    
}

struct Todo {
    enum TripleState {
        case HIGH, MEDIUM, LOW, ERR
    }
    
    let name: String
    let tags: [String]
    let timeToDo: Time
    let difficulty: TripleState
    let importance: TripleState
}
