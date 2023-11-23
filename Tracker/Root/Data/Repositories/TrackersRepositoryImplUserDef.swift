import Foundation

final class TrackersRepositoryImplUserDef: TrackersRepository {
    static let shared = TrackersRepositoryImplUserDef()
    
    private let repository = UserDefaults.standard
    
    private let key = "trackers"
    
    private var lastId: Int = -1
    
    init() {
        let trackers: [TrackerModel] = repository.getJSON(forKey: key) ?? [TrackerModel]()
        if trackers.isEmpty { return }
        
        for tracker in trackers {
            if tracker.id > lastId { lastId = tracker.id }
        }
    }
    
    func createTracker(type: TrackerType, title: String, schedule: Set<WeekDays>, emoji: String, color: TrackerColor
    ) -> TrackerModel? {
        if checkOnSimilarTitle(title) { return nil}
        
        let tracker = TrackerModel(
            id: lastId + 1,
            type: type,
            title: title,
            schedule: schedule,
            emoji: emoji,
            color: color
        )
        lastId += 1
        saveTracker(tracker)
        return tracker
    }
    
    func loadTrackers() -> [TrackerModel] {
        let trackers: [TrackerModel] = repository.getJSON(forKey: key) ?? [TrackerModel]()
        return trackers
    }
    
    func updateTracker(for trackerID: Int, type: TrackerType? = nil, title: String? = nil, schedule: Set<WeekDays>? = nil, emoji: String? = nil, color: TrackerColor? = nil
    ) -> TrackerModel? {
        guard let tracker = getTrackerByID(trackerID) else { return nil}
        
        let updatedTracker = TrackerModel(
            id: trackerID,
            type: type ?? tracker.type,
            title: title ?? tracker.title,
            schedule: schedule ?? tracker.schedule,
            emoji: emoji ?? tracker.emoji,
            color: color ?? tracker.color
        )
        var trackers = loadTrackers()
        for index in 0 ... trackers.count - 1 {
            if trackers[index].id == trackerID {
                trackers[index] = updatedTracker
                break
            }
        }
        saveTrackers(trackers)
        return updatedTracker
    }
    
    func removeTracker(id: Int) {
        var trackers = loadTrackers()
        if trackers.isEmpty { return }
        
        if getTrackerByID(id) == nil { return }
        
        for index in 0 ... trackers.count - 1 {
            if trackers[index].id == id {
                trackers.remove(at: index)
                break
            }
        }
        saveTrackers(trackers)
    }
    
    func getTrackerByID(_ id: Int) -> TrackerModel? {
        let trackers = loadTrackers()
        if trackers.isEmpty { return nil }
        
        for tracker in trackers {
            if tracker.id == id {
                return tracker
            }
        }
        return nil
    }
    
    private func saveTracker(_ tracker: TrackerModel) {
        var trackers = loadTrackers()
        trackers.append(tracker)
        saveTrackers(trackers)
    }
    
    private func saveTrackers(_ trackers: [TrackerModel]) {
        repository.setJSON(codable: trackers, forKey: key)
    }
    
    private func checkOnSimilarTitle(_ title: String) -> Bool {
        let trackers = loadTrackers()
        if trackers.isEmpty { return false }
        
        for tracker in trackers {
            if title == tracker.title { return true }
        }
        return false
    }
}
