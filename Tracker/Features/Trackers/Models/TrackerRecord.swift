import Foundation

struct TrackerRecord: Codable {
    let trackerID: Int
    let dates: Set<Date>
}
