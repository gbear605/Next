import UIKit

class TodoInputController: UIViewController {

    var table: TableViewController? = nil
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tag: UITextField!
    
    @IBOutlet weak var hours: UITextField!
    @IBOutlet weak var minutes: UITextField!
    
    @IBOutlet weak var importance: UISegmentedControl!
    @IBOutlet weak var difficulty: UISegmentedControl!
    
    func set(_ table: TableViewController) {
        self.table = table
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(save(_:)))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func save(_ sender: UIButton) {
        
        let minutesNum: Double = Double(minutes.text ?? "0") ?? 0
        let hoursNum: Double = Double(hours.text ?? "0") ?? 0
        
        let time: Time = Time(amount: minutesNum + Time.TimeUnit.MINUTES_PER_HOUR * hoursNum, unit: Time.TimeUnit.MINUTE)
        
        var importanceState: Todo.TripleState = .ERR
        
        switch importance.selectedSegmentIndex {
        case 0:
            importanceState = .LOW
        case 1:
            importanceState = .MEDIUM
        case 2:
            importanceState = .HIGH
        default:
            fatalError("ERROR: A state was selected on the importance switch that shouldn't have been possible")
        }
        
        var difficultyState: Todo.TripleState = .ERR
        
        switch difficulty.selectedSegmentIndex {
        case 0:
            difficultyState = .LOW
        case 1:
            difficultyState = .MEDIUM
        case 2:
            difficultyState = .HIGH
        default:
            fatalError("ERROR: A state was selected on the difficulty switch that shouldn't have been possible")
        }
        
        table?.create(todo: Todo(name: name.text ?? "",
                                 category: .GENERIC,
                                 tags: [TagMO.create(tag.text ?? "")],
                                 timeToDo: time,
                                 difficulty: difficultyState,
                                 importance: importanceState,
                                 displayOrder: Int32(TodoModel.numTodos(category: .GENERIC))))
    }

}
