import Foundation

struct Time: Dimension {
    typealias LocalUnit = TimeUnit
    
    static let ZERO = Time(amount: 0, unit: TimeUnit.DEFAULT_UNIT)
    
    let amount: Double
    let unit: TimeUnit
    
    enum TimeUnit: Unit {
        case MINUTE, HOUR
        static let DEFAULT_UNIT_GENERIC: Unit = TimeUnit.MINUTE
        static let DEFAULT_UNIT = DEFAULT_UNIT_GENERIC as! Time.TimeUnit
        static let MINUTES_PER_HOUR = 60.0
        
        func convertToDefault(_ amount: Double) -> Double {
            switch self {
            case .MINUTE:
                return amount
            case .HOUR:
                return amount * TimeUnit.MINUTES_PER_HOUR
            }
        }
        
        func convertFromDefault(_ amount: Double) -> Double {
            switch self {
            case .MINUTE:
                return amount
            case .HOUR:
                return amount / TimeUnit.MINUTES_PER_HOUR
            }
        }
    }
    
    func getDefaultUnit() -> Double {
        return get(in: .DEFAULT_UNIT)
    }
    
    var string: String {
        get {
            if get(in: Time.TimeUnit.MINUTE) < Time.TimeUnit.MINUTES_PER_HOUR {
                return "\(Int(get(in: Time.TimeUnit.MINUTE).truncatingRemainder(dividingBy: 60))) minutes"
            } else {
                return "\(Int(get(in: Time.TimeUnit.HOUR))) hours and \(Int(get(in: Time.TimeUnit.MINUTE).truncatingRemainder(dividingBy: 60))) minutes"
            }
        }
    }
    
    init(amount _amount: Double, unit _unit: TimeUnit) {
        amount = _amount
        unit = _unit
    }
    
    init(amount _amount: Double) {
        amount = _amount
        unit = .DEFAULT_UNIT
    }
}
