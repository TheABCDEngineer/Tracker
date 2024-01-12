import Foundation

protocol TrackersDataProcessorProtocol {
    
    func fetchAllTrackers() -> [TrackerModel]
    
    func fetchTrackersOnRequiredDateOfCompletedState(
        requiredDate: Date,
        isCompleted: Bool
    ) -> [TrackerModel]
    
    func fetchTrackersForRequiredDate(where requiredDate: Date) -> [TrackerModel]
    
    func fetchTrackerCompletionForDate(trackerID: UUID, where requiredDate: Date) -> Bool
    
    func fetchTrackerCompletionCount(trackerID: UUID) -> Int
    
    func fetchPacksForTrackers(for requiredTrackers: [TrackerModel]) -> [TrackersPack]
    
    func fetchPinnedTrackers() -> [TrackerModel]
    
    func fetchPinnedStatus(trackerID: UUID) -> Bool
    
    func fetchTrackersWhereSubTitles(
        from trackers: [TrackerModel],
        where subTitle: String
    ) -> [TrackerModel]
    
    func fetchTitleByCategoryID(_ id: UUID) -> String
    
    func fetchCategoryIDByTrackerID(_ id: UUID) -> UUID?
    
    func fetchTrackerByID(_ id: UUID) -> TrackerModel?
    
    func addRecord(for trackerID: UUID, date: Date) -> Int
    
    func removeRecord(for trackerID: UUID, date: Date) -> Int
    
    func removeTracker(id: UUID)
    
    func pinTracker(id: UUID)
    
    func unpinTracker(id: UUID)
}
