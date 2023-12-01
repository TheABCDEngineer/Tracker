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
        for trackerID: UUID,
        type: TrackerType?,
        title: String?,
        schedule: Set<WeekDays>?,
        emoji: String?,
        color: TrackerColor?
    ) -> TrackerModel?
    
    func removeTracker(id: UUID)
    
    func getTrackerByID(_ id: UUID) -> TrackerModel?
}
