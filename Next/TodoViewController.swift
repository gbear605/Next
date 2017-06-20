import UIKit

class TodoViewController: UIViewController {
    
    var table: TableViewController? = nil
    
    var todo: Todo? = nil
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeToDoLabel: UILabel!
    
    func set(_ table: TableViewController, todo: Todo) {
        self.table = table
        self.todo = todo
        
        // Set a done button that closes the view
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(popToRoot(sender:)))
        
        self.title = todo.name
    }
    
    @objc func popToRoot(sender:UIBarButtonItem) {
        table?.finishLookingInDetail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Currently there is only one tag in the list.
        // Once we implement multiple tags per todo, we will need to join them
        // with a separator
        tagLabel.text = "No tag"
        if let tagText = todo?.tags.joined()  {
            if tagText != "" {
                tagLabel.text = "Tag: " + tagText
            }
        }
        
        timeToDoLabel.text = "No time"
        if let timeText: String = todo?.timeToDo.string  {
            if timeText != "" {
                timeToDoLabel.text = "Time to do: " + timeText
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
