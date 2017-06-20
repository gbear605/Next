import Foundation

protocol Unit {
    static var DEFAULT_UNIT_GENERIC: Unit { get }
    
    func convertToDefault(_ amount: Double) -> Double
    func convertFromDefault(_ amount: Double) -> Double
}

extension Unit {
    func convert(_ amount: Double, to toType: Self) -> Double {
        return toType.convertFromDefault(self.convertToDefault(amount))
    }
}
