import Foundation

struct TrackersPack: Codable {
    let categoryID: UUID
    let trackerIDList: Set<UUID>
}
