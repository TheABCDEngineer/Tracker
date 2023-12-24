import UIKit

final class DataConverter {
    static func map(
        tracker: TrackerModel,
        daysCount: Int,
        isCompleted: Bool,
        isAvailable: Bool,
        isPinned: Bool
    ) -> TrackerScreenModel {
        return TrackerScreenModel(
            id: tracker.id,
            title: tracker.title,
            emoji: tracker.emoji,
            color: tracker.color.toUIColor(),
            daysCount: daysCount,
            isCompleted: isCompleted,
            isAvailable: isAvailable,
            isPinned: isPinned
        )
    }
}
