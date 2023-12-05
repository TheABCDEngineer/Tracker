import Foundation
import CoreData

final class TrackersRepositoryImplCoreData: TrackersRepository {
    
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    func createTracker(type: TrackerType, title: String, schedule: Set<WeekDays>, emoji: String, color: TrackerColor) -> TrackerModel? {
        if checkOnSimilarTitle(title) { return nil}
        
        let tracker = TrackerModel(
            id: UUID(),
            type: type,
            title: title,
            schedule: schedule,
            emoji: emoji,
            color: color
        )
        createManagedObject(from: tracker)
        saveTrackers()
        
        return tracker
    }
    
    func loadTrackers() -> [TrackerModel] {
        let request = TrackerCoreData.fetchRequest()
        guard let trackersData = try? context.fetch(request) else { return [TrackerModel]() }
        
        return trackersData.compactMap({CoreDataMarshalling.map($0)})
    }
    
    func updateTracker(for trackerID: UUID, type: TrackerType? = nil, title: String? = nil, schedule: Set<WeekDays>? = nil, emoji: String? = nil, color: TrackerColor? = nil
    ) -> TrackerModel? {
        guard let trackerCoreData = getTrackerCoreDataByID(trackerID) else { return nil }
        
        if type != nil { trackerCoreData.type = CoreDataMarshalling.encode(type) }
        if title != nil { trackerCoreData.title = title }
        if schedule != nil { trackerCoreData.schedule = CoreDataMarshalling.encode(schedule) }
        if emoji != nil { trackerCoreData.emoji = emoji }
        if color != nil { trackerCoreData.color = CoreDataMarshalling.encode(color) }
        
        saveTrackers()
        
        guard let tracker = CoreDataMarshalling.map(trackerCoreData) else { return nil }
        
        return TrackerModel(
            id: trackerID,
            type: type ?? tracker.type,
            title: title ?? tracker.title,
            schedule: schedule ?? tracker.schedule,
            emoji: emoji ?? tracker.emoji,
            color: color ?? tracker.color
        )
    }
    
    func removeTracker(id: UUID) {
        guard let trackerCoreData = getTrackerCoreDataByID(id) else { return }
        context.delete(trackerCoreData)
        saveTrackers()
    }
    
    func getTrackerByID(_ id: UUID) -> TrackerModel? {
        guard let trackerData = getTrackerCoreDataByID(id) else { return nil }
        return CoreDataMarshalling.map(trackerData)
    }
    
    private func getTrackerCoreDataByID(_ id: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.id_), id.uuidString)
        
        guard let trackersData = try? context.fetch(request) else { return nil }
        if trackersData.isEmpty { return nil }
        
        return trackersData[0]
    }
    
    private func saveTrackers() {
        Creator.saveCoreDataContex(context)
    }

    
    private func checkOnSimilarTitle(_ title: String) -> Bool {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.title), title)
        
        guard let trackersData = try? context.fetch(request) else { return false }
        
        return !trackersData.isEmpty
    }
    
    private func createManagedObject(from model: TrackerModel) {
        guard let typeData = CoreDataMarshalling.encode(model.type),
              let scheduleData = CoreDataMarshalling.encode(model.schedule),
              let colorData = CoreDataMarshalling.encode(model.color)
        else { return }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id_ = model.id
        trackerCoreData.type = typeData
        trackerCoreData.title = model.title
        trackerCoreData.schedule = scheduleData
        trackerCoreData.emoji = model.emoji
        trackerCoreData.color = colorData
    }
}
