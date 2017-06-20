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
        
        table?.create(todo: Todo(name: name.text ?? "", tags: [tag.text ?? ""], timeToDo: time))
    }

}
