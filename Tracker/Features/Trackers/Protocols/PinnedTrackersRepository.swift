import Foundation

protocol PinnedTrackersRepository {
    
    func pin(trackerID: UUID)
    
    func unpin(trackerID: UUID)
    
    func getPinnedStatus(trackerID: UUID) -> Bool
    
    func loadPinnedTrackers() -> Set<UUID>
}
