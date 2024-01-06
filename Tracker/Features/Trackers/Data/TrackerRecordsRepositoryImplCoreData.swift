import Foundation
import CoreData

final class TrackerRecordsRepositoryImplCoreData: TrackerRecordsRepository {
    
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    func loadRecords() -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        guard let trackerRecordsData = try? context.fetch(request) else { return [TrackerRecord]() }
        
        return trackerRecordsData.compactMap({CoreDataMarshalling.map($0)})
    }
    
    func getRecordByTrackerID(for trackerID: UUID) -> TrackerRecord? {
        guard let trackerRecordCoreData = getTrackerRecordCoreDataByID(trackerID) else { return nil }
        return CoreDataMarshalling.map(trackerRecordCoreData)
    }
    
    func saveRecord(for trackerID: UUID, date: Date) -> TrackerRecord {
        let _date = DateFormatterObj.shared.convertToInt(date)
        if let trackerRecordCoreData = getTrackerRecordCoreDataByID(trackerID) {
            if let trackerRecord = CoreDataMarshalling.map(trackerRecordCoreData) {
                var dates = trackerRecord.dates
                dates.insert(_date)
                trackerRecordCoreData.dates = CoreDataMarshalling.encode(dates)
                saveRecords()
                return TrackerRecord(trackerID: trackerID, dates: dates)
            }
        }
        let newTrackerRecord = TrackerRecord(trackerID: trackerID, dates: [_date])
        createManagedObject(from: newTrackerRecord)
        saveRecords()
        return newTrackerRecord
    }
    
    func removeRecord(for trackerID: UUID, date: Date) {
        guard let trackerRecordCoreData = getTrackerRecordCoreDataByID(trackerID) else { return }
        guard let trackerRecord = CoreDataMarshalling.map(trackerRecordCoreData) else { return }
        
        var dates = trackerRecord.dates
        dates.remove(DateFormatterObj.shared.convertToInt(date))
        
        if dates.isEmpty {
            context.delete(trackerRecordCoreData)
            saveRecords()
            return
        }
        trackerRecordCoreData.dates = CoreDataMarshalling.encode(dates)
        saveRecords()
    }
    
    func removeRecords(for trackerID: UUID) {
        guard let trackerRecordCoreData = getTrackerRecordCoreDataByID(trackerID) else { return }
        context.delete(trackerRecordCoreData)
        saveRecords()
    }
    
    private func getTrackerRecordCoreDataByID(_ id: UUID) -> TrackerRecordCoreData? {
        let request = TrackerRecordCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        
        guard let trackerRecordsData = try? context.fetch(request) else { return nil }
        if trackerRecordsData.isEmpty { return nil }
        
        return trackerRecordsData[0]
    }
    
    private func saveRecords() {
        Creator.saveCoreDataContex(context)
    }
    
    func createManagedObject(from model: TrackerRecord) {
        guard let datesData = CoreDataMarshalling.encode(model.dates) else { return }
        
        let newTrackerRecordCoreData = TrackerRecordCoreData(context: context)
        newTrackerRecordCoreData.trackerID = model.trackerID
        newTrackerRecordCoreData.dates = datesData
    }
}
