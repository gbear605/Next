import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
                
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        self.title = "Generic"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    @objc func addItem(_ sender: UIBarButtonItem) {
        // Create a controller for the view for creating the todo.
        let todoInputController = TodoInputController()
        
        // Tell the controller that it should save the todo to this controller
        // (It calls the save:table: function)
        todoInputController.set(self)
        
        // Create a navigation controller to contain the todo input controller
        let navigationController = UINavigationController.init(rootViewController: todoInputController)
        
        //Display the navigation view containing the todo input view on top of this view
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    func create(todo: Todo) {
        // Hide the todo input controller
        dismiss(animated: true, completion: nil)

        TodoModel.addGeneric(todo: todo)
        
        // Tell the table view it needs to show the todo appearing
        tableView.insertRows(at: [IndexPath.init(row: TodoModel.numGenericTodos() - 1, section: 0)], with: .fade)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoModel.numGenericTodos()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        cell.textLabel?.text = TodoModel.getGeneric(from: indexPath.row).name

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            TodoModel.removeGeneric(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let valueToMove = TodoModel.getGeneric(from: fromIndexPath.row)
        
        TodoModel.removeGeneric(at: fromIndexPath.row)
        TodoModel.addGeneric(todo: valueToMove, at: to.row)

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoViewController = TodoViewController()
        print(TodoModel.numGenericTodos())
        
        let navigationController = UINavigationController.init(rootViewController: todoViewController)

        
        self.navigationController?.present(navigationController, animated: true, completion: nil)

        todoViewController.set(self, todo: TodoModel.getGeneric(from: indexPath.row))
        
    }
    
    func finishLookingInDetail() {
        dismiss(animated: true, completion: nil)
    }

}