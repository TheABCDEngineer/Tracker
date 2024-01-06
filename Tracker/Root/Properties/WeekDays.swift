import Foundation

enum WeekDays: Int, CaseIterable, Codable {
    case monday = 0
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    func description() -> String {
        switch self {
        case .monday: return localized("monday")
        case .tuesday: return localized("tuesday")
        case .wednesday: return localized("wednesday")
        case .thursday: return localized("thursday")
        case .friday: return localized("friday")
        case .saturday: return localized("saturday")
        case .sunday: return localized("sunday")
        }
    }
    
    func shortDescription() -> String {
        switch self {
        case .monday: return localized("monday.short")
        case .tuesday: return localized("tuesday.short")
        case .wednesday: return localized("wednesday.short")
        case .thursday: return localized("thursday.short")
        case .friday: return localized("friday.short")
        case .saturday: return localized("saturday.short")
        case .sunday: return localized("sunday.short")
        }
    }
    
    static func sort(_ set: Set<WeekDays>) -> Dictionary<Int, WeekDays> {
        var result = Dictionary<Int, WeekDays>()
        
        for day in set {
            result.updateValue(day, forKey: day.rawValue)
        }
        return result
    }
    
    static func sort(_ array: [WeekDays]) -> Dictionary<Int, WeekDays> {
        var result = Dictionary<Int, WeekDays>()
        
        for day in array {
            result.updateValue(day, forKey: day.rawValue)
        }
        return result
    }
}
