import Foundation
import UIKit

class DataManager {
    
    let url: URL = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent("Documents")
        .appendingPathComponent("data.json")
    
    init() {
        do {
            guard FileManager.default.fileExists(atPath: url.path) else {
                // Make sure that the file exists
                return
            }
            
            // Get the data from the file
            let data = try Data(contentsOf: url)
            
            // Turn the data into a dictionary of strings matching with anything
            let todos = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            
            for todo in todos {
                // Save is false so that todos aren't lost 
                // if the app crashes while this is happening
                TodoModel.addGeneric(todo: makeTodo(from: todo), save: false)
            }
        }
        catch {
            print("Error in reading saved todos: \(error)")
        }
    }
    
    func makeTodo(from json: [String: Any]) -> Todo {
        // When adding new members to the Todo struct, provide defaults
        // so that old save files will continue to work.
        // Also so corrupt files will parse mostly correctly.
        // (That hopefully shouldn't be needed though!)

        let timeToDoMinutes: Double = json["timeToComplete"] as? Double ?? 0.0
        let timeToDo: Time = Time(amount: timeToDoMinutes, unit: Time.TimeUnit.MINUTE)
        
        let name: String = json["name"] as? String ?? ""
        
        let tags: [String] = json["tags"] as? [String] ?? []
        
        let difficultyString: String = json["difficulty"] as? String ?? ""
        
        var difficulty: Todo.TripleState = .ERR
        switch difficultyString {
        case "HIGH":
            difficulty = .HIGH
        case "MEDIUM":
            difficulty = .MEDIUM
        case "LOW":
            difficulty = .LOW
        default:
            break
        }
            
        let importanceString: String = json["importance"] as? String ?? ""
        
        var importance: Todo.TripleState = .ERR
        switch importanceString {
        case "HIGH":
            importance = .HIGH
        case "MEDIUM":
            importance = .MEDIUM
        case "LOW":
            importance = .LOW
        default:
            break
        }
        
        return Todo(
            name: name,
            tags: tags,
            timeToDo: timeToDo,
            difficulty: difficulty,
            importance: importance
        )
    }
    
    func makeDictionary(from todo: Todo) -> [String: Any] {
        return [
            "name" : todo.name,
            "tags" : todo.tags,
            "timeToComplete" : todo.timeToDo.get(in: Time.TimeUnit.MINUTE),
            "importance" : "\(todo.importance)",
            "difficulty" : "\(todo.difficulty)"
        ]
    }
    
    func save(todos: [Todo]) {
        save(dictionary: todos.map(makeDictionary))
    }
    
    func save(dictionary: [[String:Any]]) {
        do {
            //Serialize the dictionary to a json (Data) object
            let rawJSON: Data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            
            //Write the data to the file save path
            try rawJSON.write(to: url)
        } catch {
            print("Serialization error: \(error)")
        }
    }
}
