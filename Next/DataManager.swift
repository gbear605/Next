import Foundation
import UIKit

class DataManager {
    
    static func getURL(for category: TodoModel.Category) -> URL {
        //Get the url for a file in the application's document directory
        // with a name like generic_data.json
        return URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Documents")
            .appendingPathComponent("\("\(category)".lowercased())_data.json")
    }
    
    var urls: [TodoModel.Category: URL] = [:]
    
    func saveURL(for category: TodoModel.Category) {
        let url = DataManager.getURL(for: category)
        urls[category] = url
    }
    
    func loadData(for category: TodoModel.Category) {
        do {
            guard FileManager.default.fileExists(atPath: urls[category]!.path) else {
                // Make sure that the file exists
                return
            }
            
            // Get the data from the file
            let data = try Data(contentsOf: urls[category]!)
            
            // Turn the data into a dictionary of strings matching with anything
            let todos = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            
            for todo in todos {
                // Save is false so that todos aren't lost
                // if the app crashes while this is happening
                TodoModel.add(category, todo: make(category, from: todo), save: false)
            }
        }
        catch {
            print("Error in reading saved todos: \(error)")
        }
    }
    
    init() {
        for category in TodoModel.Category.list {
            saveURL(for: category)
            loadData(for: category)
        }
        
    }
    
    func make(_ category: TodoModel.Category, from json: [String: Any]) -> Todo {
        // When adding new members to the Todo struct, provide defaults
        // so that old save files will continue to work.
        // Also so corrupt files will parse mostly correctly.
        // (That hopefully shouldn't be needed though!)

        let timeToDoMinutes: Double = json["timeToComplete"] as? Double ?? 0.0
        let timeToDo: Time = Time(amount: timeToDoMinutes, unit: Time.TimeUnit.MINUTE)
        
        let name: String = json["name"] as? String ?? ""
        
        let tags: [String] = json["tags"] as? [String] ?? []
        
        let difficulty: Todo.TripleState = Todo.TripleState(from: json["difficulty"] as? String)
                    
        let importance: Todo.TripleState = Todo.TripleState(from: json["importance"] as? String)
        
        return Todo(
            name: name,
            category: category,
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
    
    func save(todos: [TodoModel.Category:[Todo]]) {
        for (category, specificTodos) in todos {
            save(category: category, dictionary: specificTodos.map(makeDictionary))
        }
    }
    
    func save(category: TodoModel.Category, dictionary: [[String:Any]]) {
        do {
            //Serialize the dictionary to a json (Data) object
            let rawJSON: Data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            
            //Write the data to the file save path
            try rawJSON.write(to: urls[category]!)
        } catch {
            print("Serialization error: \(error)")
        }
    }
}
