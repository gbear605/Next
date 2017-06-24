import Foundation

class TodoModel {
    
    enum Category {
        case GENERIC, DEPENDENT, NOW, LONGTERM, EVENT
        
        static let list: [Category] = [.GENERIC, .DEPENDENT, .NOW, .LONGTERM, .EVENT]
    }
    
    static var todos: [Category:[Todo]] = [.GENERIC:[], .DEPENDENT:[], .NOW:[], .LONGTERM:[], .EVENT:[]]
    
    static func add(_ category: Category, todo toAdd: Todo, at index: Int, save: Bool = true) {
        todos[category]!.insert(toAdd, at: index)
        if save {
            saveTodos()
        }
    }
    
    static func add(_ category: Category, todo toAdd: Todo, save: Bool = true) {
        todos[category]!.append(toAdd)
        if save {
            saveTodos()
        }
    }
    
    static func numTodos(category: Category) -> Int {
        return todos[category]!.count
    }
    
    static func get(_ category: Category, from index: Int) -> Todo {
        return todos[category]![index]
    }
    
    static func remove(_ category: Category, at index: Int, save: Bool = true) {
        todos[category]!.remove(at: index)
        if save {
            saveTodos()
        }
    }
    
    static private func saveTodos() {
        AppDelegate.dataManager?.save(todos: todos)
    }
    
}

struct Todo {
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
    
    let name: String
    let category: TodoModel.Category
    let tags: [String]
    let timeToDo: Time
    let difficulty: TripleState
    let importance: TripleState
}
