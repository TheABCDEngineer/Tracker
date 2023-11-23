import Foundation

protocol TrackersDataProcessorProtocol {
    
    func fetchAllTrackers() -> [TrackerModel]
    
    func fetchTrackersOnRequiredDateOfCompletedState(
        requiredDate: Date,
        isCompleted: Bool
    ) -> [TrackerModel]
    
    func fetchTrackersForRequiredDate(where requiredDate: Date) -> [TrackerModel]
    
    func fetchTrackerCompletionForDate(trackerID: Int, where requiredDate: Date) -> Bool
    
    func fetchTrackerCompletionCount(trackerID: Int) -> Int
    
    func fetchPacksForTrackers(for requiredTrackers: [TrackerModel]) -> [TrackersPack]
    
    func fetchTitleByCategoryID(_ id: Int) -> String
    
    func fetchTrackerByID(_ id: Int) -> TrackerModel?
    
    func addRecord(for trackerID: Int, date: Date) -> Int
    
    func removeRecord(for trackerID: Int, date: Date) -> Int
    
    func removeTracker(id: Int)
}
