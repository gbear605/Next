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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
