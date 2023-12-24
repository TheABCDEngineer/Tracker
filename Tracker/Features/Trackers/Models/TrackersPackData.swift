import Foundation

struct TrackersPackData: Comparable {
    let title: String
    let categoryID: UUID?
    var trackers: [TrackerModel]
    
    static func < (lhs: TrackersPackData, rhs: TrackersPackData) -> Bool {
        lhs.title.hash < rhs.title.hash
    }
    
    static func == (lhs: TrackersPackData, rhs: TrackersPackData) -> Bool {
        lhs.title.hash == rhs.title.hash
    }
}
