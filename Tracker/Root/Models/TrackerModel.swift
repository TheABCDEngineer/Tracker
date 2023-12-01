import UIKit

struct TrackerModel: Codable {
    let id: UUID
    let type: TrackerType
    let title: String
    let schedule: Set<WeekDays>
    let emoji: String
    let color: TrackerColor
}
