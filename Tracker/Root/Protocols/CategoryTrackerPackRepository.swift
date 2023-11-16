import Foundation

protocol CategoryTrackerPackRepository {
    func loadPacks() -> [CategoryTrackerPack]
    func addTrackerToCategory(with tracker: TrackerModel, to category: TrackerCategory)
    func removeTrackerFromCategory(with tracker: TrackerModel, from category: TrackerCategory)
}
