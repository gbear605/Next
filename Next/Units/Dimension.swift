import Foundation

protocol Dimension {
    associatedtype LocalUnit: Unit
    
    var amount: Double { get }
    var unit: LocalUnit { get }
    
    
    init(amount _amount: Double, unit _unit: LocalUnit)
    init(amount _amount: Double)
    
    func getDefaultUnit() -> Double
}

extension Dimension {
    func get(in toUnit: LocalUnit) -> Double {
        return unit.convert(amount, to: toUnit)
    }
    
    static func +(left: Self, right: Self) -> Self {
        return Self(amount: left.getDefaultUnit() + right.getDefaultUnit())
    }
}

