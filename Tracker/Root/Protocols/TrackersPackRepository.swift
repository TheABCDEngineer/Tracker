import Foundation

protocol TrackersPackRepository {
    func loadPacks() -> [TrackersPack]
    func addTrackerToCategory(trackerID: Int, categoryID: Int)
    func removeTrackerFromCategory(trackerID: Int)
}
