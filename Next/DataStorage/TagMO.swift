import Foundation
import CoreData

@objc(TagMO)
public class TagMO: NSManagedObject {
    
    @NSManaged var text: String
    
    static func create(_ text: String) -> TagMO {
        let tag: TagMO = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: DataManager.singleton.managedContext!) as! TagMO
        tag.text = text
        return tag
    }
    
}
