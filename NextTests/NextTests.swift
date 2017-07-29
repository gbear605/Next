import XCTest
@testable import Next

class NextTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTime() {
        
        let time20Minutes: Time = Time(amount: 20, unit: Time.TimeUnit.MINUTE)
        
        XCTAssert(time20Minutes.get(in: Time.TimeUnit.MINUTE) == 20)
        XCTAssert(time20Minutes.get(in: Time.TimeUnit.HOUR) == 1.0/3.0)
        
        XCTAssert(time20Minutes.string == "20 minutes")
        
        let time2Hours20Minutes: Time = Time(amount: 2.0 + 1.0/3.0, unit: Time.TimeUnit.HOUR)
        
        XCTAssert(time2Hours20Minutes.get(in: Time.TimeUnit.MINUTE) == 140)
        XCTAssert(time2Hours20Minutes.get(in: Time.TimeUnit.HOUR) == 2.0 + 1.0/3.0)
        
        XCTAssert(time2Hours20Minutes.string == "2 hours and 20 minutes")
    }
    
    func testTodoModel() {
        
        let model = TodoModel()
        
        let sampleTodoOne = Todo(name: "TestOne", category: .GENERIC, tags: [], timeToDo: Time.init(amount: 1, unit: .MINUTE), difficulty: .LOW, importance: .LOW, displayOrder: 0)
        let sampleTodoTwo = Todo(name: "TestTwo", category: .GENERIC, tags: [], timeToDo: Time.init(amount: 1, unit: .MINUTE), difficulty: .LOW, importance: .LOW, displayOrder: 1)
        let sampleTodoThree = Todo(name: "TestThree", category: .GENERIC, tags: [], timeToDo: Time.init(amount: 1, unit: .MINUTE), difficulty: .LOW, importance: .LOW, displayOrder: 2)
        
        
        model.add(todo: sampleTodoOne)
        model.add(todo: sampleTodoTwo)
        model.add(todo: sampleTodoThree)
        
        testModelForLegalDisplayOrder(model)
        
        model.move(.GENERIC, from: 2, to: 0)
        
        testModelForLegalDisplayOrder(model)
        
        model.move(.GENERIC, from: 0, to: 2)
        
        testModelForLegalDisplayOrder(model)
        
        model.move(.GENERIC, from: 2, to: 1)
        
        testModelForLegalDisplayOrder(model)
        
        model.move(.GENERIC, from: 1, to: 2)
        
        testModelForLegalDisplayOrder(model)
        
        model.move(.GENERIC, from: 1, to: 0)
        
        testModelForLegalDisplayOrder(model)
        
        model.move(.GENERIC, from: 0, to: 1)
        
        testModelForLegalDisplayOrder(model)
        
        model.delete(.GENERIC, at: 1)
        
        testModelForLegalDisplayOrder(model)
        
        model.add(todo: Todo(name: "TestTwo", category: .GENERIC, tags: [], timeToDo: Time.init(amount: 1, unit: .MINUTE), difficulty: .LOW, importance: .LOW, displayOrder: 1), at: 1)
        
        testModelForLegalDisplayOrder(model)
        
        model.delete(.GENERIC, at: 0)
        
        testModelForLegalDisplayOrder(model)
        
        model.add(todo: Todo(name: "TestOne", category: .GENERIC, tags: [], timeToDo: Time.init(amount: 1, unit: .MINUTE), difficulty: .LOW, importance: .LOW, displayOrder: 1), at: 0)
        
        testModelForLegalDisplayOrder(model)
        
        model.delete(.GENERIC, at: 2)
        
        testModelForLegalDisplayOrder(model)
        
        model.add(todo: Todo(name: "TestThree", category: .GENERIC, tags: [], timeToDo: Time.init(amount: 1, unit: .MINUTE), difficulty: .LOW, importance: .LOW, displayOrder: 1), at: 2)
        
        testModelForLegalDisplayOrder(model)
        
    }
    
    private func testModelForLegalDisplayOrder(_ model: TodoModel) {
        for category in TodoModel.Category.list {
            testTodosForLegalDisplayOrder(model.get(category))
        }
    }
        
    
    private func testTodosForLegalDisplayOrder(_ todos: [Todo]) {
        var checklist: [Bool] = Array(repeating: false, count: todos.count)
        for todo: Todo in todos {
            if todo.displayOrder >= todos.count {
                XCTAssert(false, "Todo \(todo) display order is \(todo.displayOrder) which is greater than or equal to the number of todos which is \(todos.count)")
            } else {
                if checklist[todo.displayOrder] == true {
                    XCTAssert(false, "Todo \(todo) display order is \(todo.displayOrder) which is the same as a different todo")
                } else {
                    checklist[todo.displayOrder] = true
                }
            }
        }
        
        for check in checklist {
            XCTAssert(check == true, "Not all items in the checklist are checked")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
