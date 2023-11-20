import Foundation

protocol TrackerRecordsRepository {
    
    func loadRecords() -> [TrackerRecord]
    
    func getRecordByTrackerID(for trackerID: Int, from records: [TrackerRecord]) -> TrackerRecord?
    
    func saveRecord(for trackerID: Int, date: Date) -> TrackerRecord
    
    func removeRecord(for trackerID: Int, date: Date)
}
