import Foundation

enum FilterState: Int, CaseIterable {
    case allTrackers = 0
    case todayTrackers
    case completedTrackers
    case uncompletedTrackers
    
    func description() -> String {
        switch self {
        case .allTrackers:
            return "Все трекеры"
        case .todayTrackers:
            return "Трекеры на сегодня"
        case .completedTrackers:
            return "Завершенные"
        case .uncompletedTrackers:
            return "Не завершенные"
        }
    }
}
