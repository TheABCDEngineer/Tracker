import Foundation

protocol TrackersPackRepository {
    
    func loadPacks() -> [TrackersPack]
    
    func addTrackerToCategory(trackerID: Int, categoryID: Int)
    
    func removeTrackerFromCategory(trackerID: Int)
    
    func getPackByTrackerID(_ trackerID: Int) -> TrackersPack?
    
    func getPackByCategoryID(_ categoryID: Int) -> TrackersPack?
    
    func removePack(for categoryID: Int)
}
