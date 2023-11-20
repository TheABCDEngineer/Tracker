import Foundation

final class TrackerRecordsRepositoryImplUserDef: TrackerRecordsRepository {
    
    let repository = UserDefaults.standard
    
    let key = "trackersRecords"
    
    func loadRecords() -> [TrackerRecord] {
        let records: [TrackerRecord] = repository.getJSON(forKey: key) ?? [TrackerRecord]()
        return records
    }
    
    func getRecordByTrackerID(for trackerID: Int, from records: [TrackerRecord]) -> TrackerRecord? {
        if records.isEmpty { return nil }
        
        var trackerRecord: TrackerRecord?
        
        for record in records {
            if record.trackerID == trackerID {
                trackerRecord = record
                break
            }
        }
        return trackerRecord
    }
    
    func saveRecord(for trackerID: Int, date: Date) -> TrackerRecord {
        var dates = Set<Date>()
        if let initRecord = getRecordByTrackerID(for: trackerID, from: loadRecords()) {
            dates = initRecord.dates
        }
        dates.insert(date)
        
        let updatedRecord = TrackerRecord(trackerID: trackerID, dates: dates)
        saveRecord(updatedRecord)
        return updatedRecord
    }
    
    func removeRecord(for trackerID: Int, date: Date) {
        guard let initRecord = getRecordByTrackerID(for: trackerID, from: loadRecords()) else { return }
        var dates = initRecord.dates
        if dates.isEmpty { return }
        
        for day in dates {
            if DateFormatterObj.shared.checkPairDatesOnEqual(day, date) {
                dates.remove(day)
                break
            }
        }
        
        if dates.isEmpty {
            removeRecords(for: trackerID)
            return
        }
        
        let updatedRecord = TrackerRecord(trackerID: trackerID, dates: dates)
        saveRecord(updatedRecord)
    }
    
    private func saveRecords(_ records: [TrackerRecord]) {
        repository.setJSON(codable: records, forKey: key)
    }
    
    private func saveRecord(_ record: TrackerRecord) {
        var records = loadRecords()
        
        if !records.isEmpty {
            for index in 0 ... records.count - 1 {
                if records[index].trackerID == record.trackerID {
                    records.remove(at: index)
                    break
                }
            }
        }
        records.append(record)
        saveRecords(records)
    }
    
    private func removeRecords(for trackerID: Int ) {
        var records = loadRecords()
        if records.isEmpty { return }
        
        for index in 0 ... records.count - 1 {
            if records[index].trackerID == trackerID {
                records.remove(at: index)
                saveRecords(records)
                break
            }
        }
    }
}
