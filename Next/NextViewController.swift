import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var nextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func next(_ sender: UIButton) {
        var flagTodosToPickFrom = false
        for category in TodoModel.Category.list {
            if TodoModel.numTodos(category: category) > 0 {
                flagTodosToPickFrom = true
                nextLabel.text = TodoModel.get(category, from: 0).name
            }
        }
        if !flagTodosToPickFrom {
            nextLabel.text = "Make a todo!"
        }
    }
    
}

