import Foundation

protocol TrackerRecordsRepository {
    
    func loadRecords() -> [TrackerRecord]
    
    func getRecordByTrackerID(for trackerID: Int) -> TrackerRecord?
    
    func saveRecord(for trackerID: Int, date: Date) -> TrackerRecord
    
    func removeRecord(for trackerID: Int, date: Date)
    
    func removeRecords(for trackerID: Int)
}
