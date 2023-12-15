import Foundation

struct TrackerRecord: Codable {
    let trackerID: UUID
    let dates: Set<Date>
}
