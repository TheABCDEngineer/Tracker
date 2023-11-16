import Foundation

struct CategoryTrackerPack: Codable {
    let categoryID: Int
    let trackerIDList: Set<Int>
}
