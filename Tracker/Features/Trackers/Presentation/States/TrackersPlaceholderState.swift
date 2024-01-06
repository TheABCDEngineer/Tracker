import UIKit

final class TrackersPlaceholder {
    struct State {
        let id: String
        let image: UIImage
        let message: String
    }
    
    static let noContent = State(
        id: "noContent",
        image: UIImage(named: "TrackerPlaceholder") ?? UIImage(),
        message: localized("trackers.noContent.placeholder")
    )
    
    static let emptyResults = State(
        id: "emptyResults",
        image: UIImage(named: "EmptyResultsPlaceholder") ?? UIImage(),
        message: localized("trackers.emptyResults.placeholder")
    )
}
