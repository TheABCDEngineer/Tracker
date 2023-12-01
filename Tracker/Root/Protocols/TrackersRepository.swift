import Foundation

protocol TrackersRepository {
    func createTracker(
        type: TrackerType,
        title: String,
        schedule: Set<WeekDays>,
        emoji: String,
        color: TrackerColor
    ) -> TrackerModel?
    
    func loadTrackers() -> [TrackerModel]
    
    func updateTracker(
        for trackerID: Int,
        type: TrackerType?,
        title: String?,
        schedule: Set<WeekDays>?,
        emoji: String?,
        color: TrackerColor?
    ) -> TrackerModel?
    
    func removeTracker(id: Int)
    
    func getTrackerByID(_ id: Int) -> TrackerModel?
}
