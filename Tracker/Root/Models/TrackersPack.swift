import Foundation

struct TrackersPack: Codable {
    let categoryID: Int
    let trackerIDList: Set<Int>
}
