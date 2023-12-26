import Foundation

enum FilterState: Int, CaseIterable {
    case allTrackers = 0
    case todayTrackers
    case completedTrackers
    case uncompletedTrackers
    
    func description() -> String {
        switch self {
        case .allTrackers:
            return localized("filter.allTrackers")
        case .todayTrackers:
            return localized("filter.todayTrackers")
        case .completedTrackers:
            return localized("filter.completedTrackers")
        case .uncompletedTrackers:
            return localized("filter.uncompletedTrackers")
        }
    }
}
