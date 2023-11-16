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
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    func shortDescription() -> String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
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
