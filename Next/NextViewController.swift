import UIKit

class NextViewController: UIViewController, CanViewTodos {
    func finishLookingInDetail() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        TodoModel.singleton.addUpdateListener {_ in
            self.ignoring.removeAll()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        TodoModel.singleton.addUpdateListener {_ in
            self.ignoring.removeAll()
        }
    }
    
    
    @IBOutlet weak var nextLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var ignoring: [Todo] = []
    private let numToIgnore = 3
    
    private func addNewIgnoring(todo: Todo) {
        if ignoring.count < numToIgnore {
            ignoring.append(todo)
        } else {
            ignoring.remove(at: 0)
            ignoring.append(todo)
        }
    }
    
    private func getNextTodo(from todos: [Todo]) -> Todo? {
        // We don't want to show repeats so we ignore the last numToIgnore shown,
        // but if there are numToIgnore or fewer total todos,
        //   then we need to ignore fewer than the last numToIgnore
        // but if we just started and we haven't ignored many so far,
        //   then we need to really do need to ignore them since otherwise it'll repeat the same one
        // and we can't drop fewer than 0, since that makes no sense.
        
        // TODO: This algorithm is still stupid at low todo counts
        
        let numToDrop = max(0, min(1 + numToIgnore - todos.count, ignoring.count - 1))
        let toIgnore = Array(ignoring.dropFirst(numToDrop))
        
        return Todo.findOptimalTodo(from: todos, ignoring: toIgnore)
    }
    
    private func getNextTodo(from category: TodoModel.Category) -> Todo? {
        return getNextTodo(from: TodoModel.singleton.get(category))
    }
    
    var nextTodo: Todo? {
        get {
            for category in TodoModel.Category.list {
                if let todo = getNextTodo(from: category) {
                    return todo
                }
            }
            return nil
        }
    }
    
    var currentlyVisibleTodo: Todo? = nil
    
    @IBAction func next(_ sender: UIButton) {
        currentlyVisibleTodo = nextTodo
        if let nextTodo = nextTodo {
            addNewIgnoring(todo: nextTodo)
            nextLabel.setTitle(nextTodo.name, for: .normal)
        } else {
            nextLabel.setTitle("Make a todo", for: .normal)
        }
    }
    
    @IBAction func view(_ sender: UIButton) {
        guard let currentlyVisibleTodo = currentlyVisibleTodo else { return }
        let todoViewController = TodoViewController()
        
        let navigationController = UINavigationController.init(rootViewController: todoViewController)
        
        self.present(navigationController, animated: true, completion: nil)
        todoViewController.set(self, todo: currentlyVisibleTodo)
        
    }
    
    
}

