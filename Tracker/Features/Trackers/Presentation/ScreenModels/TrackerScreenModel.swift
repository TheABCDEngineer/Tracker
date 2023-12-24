import UIKit

struct TrackerScreenModel {
    let id: UUID
    let title: String
    let emoji: String
    let color: UIColor
    let daysCount: Int
    let isCompleted: Bool
    let isAvailable: Bool
    let isPinned: Bool
}
