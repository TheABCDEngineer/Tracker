import Foundation

final class PinnedTrackersRepositoryImplUserDef: PinnedTrackersRepository {
    
    private let repository = UserDefaults.standard
    
    private let key = "pinnedTrackers"
    
    func pin(trackerID: UUID) {
        if getPinnedStatus(trackerID: trackerID) { return }
        
        var trackers = loadPinnedTrackers()
        trackers.insert(trackerID)
        savePinnedTrackers(trackers)
    }
    
    func unpin(trackerID: UUID) {
        if !getPinnedStatus(trackerID: trackerID) { return }
        
        var trackers = loadPinnedTrackers()
        trackers.remove(trackerID)
        savePinnedTrackers(trackers)
    }
    
    func getPinnedStatus(trackerID: UUID) -> Bool {
        let trackers = loadPinnedTrackers()
        
        if trackers.contains(trackerID) { return true }
        return false
    }
    
    func loadPinnedTrackers() -> Set<UUID> {
        guard let trackers: Set<UUID> = repository.getJSON(forKey: key) else { return Set<UUID>() }
        return trackers
    }
    
    private func savePinnedTrackers(_ trackers: Set<UUID>) {
        repository.setJSON(codable: trackers, forKey: key)
    }
}
