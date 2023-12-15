import Foundation

protocol TrackersPackRepository {
    
    func loadPacks() -> [TrackersPack]
    
    func addTrackerToCategory(trackerID: UUID, categoryID: UUID)
    
    func removeTrackerFromCategory(trackerID: UUID)
    
    func getPackByTrackerID(_ trackerID: UUID) -> TrackersPack?
    
    func getPackByCategoryID(_ categoryID: UUID) -> TrackersPack?
    
    func removePack(for categoryID: UUID)
}
