import Foundation

protocol TrackerRecordsRepository {
    
    func loadRecords() -> [TrackerRecord]
    
    func getRecordByTrackerID(for trackerID: UUID) -> TrackerRecord?
    
    func saveRecord(for trackerID: UUID, date: Date) -> TrackerRecord
    
    func removeRecord(for trackerID: UUID, date: Date)
    
    func removeRecords(for trackerID: UUID)
}
