import Foundation
import CoreData

final class TrackersPackRepositoryImplCoreData: TrackersPackRepository {
    
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    func loadPacks() -> [TrackersPack] {
        let request = TrackersPackCoreData.fetchRequest()
        guard let trackersPacksData = try? context.fetch(request) else { return [TrackersPack]() }
        
        return trackersPacksData.compactMap({CoreDataMarshalling.map($0)})
    }
    
    func addTrackerToCategory(trackerID: UUID, categoryID: UUID) {
        if let pack = getPackByCategoryID(categoryID) {
            var trackerIDList = pack.trackerIDList
            trackerIDList.insert(trackerID)
            guard let packCoreData = getPackCoreDataByCategoryID(categoryID) else { return }
            packCoreData.trackerIDList = CoreDataMarshalling.encode(trackerIDList)
            savePacks()
            return
        }
        createManagedObject(
            from: TrackersPack(categoryID: categoryID, trackerIDList: [trackerID])
        )
        savePacks()
    }
    
    func removeTrackerFromCategory(trackerID: UUID) {
        guard let pack = getPackByTrackerID(trackerID) else { return }
        
        var trackerIDList = pack.trackerIDList
       
        trackerIDList.remove(trackerID)
        
        if trackerIDList.isEmpty {
            removePack(for: pack.categoryID)
            return
        }
        
        guard let packData = getPackCoreDataByCategoryID(pack.categoryID) else { return }
        packData.trackerIDList = CoreDataMarshalling.encode(trackerIDList)
        savePacks()
    }
    
    func getPackByTrackerID(_ trackerID: UUID) -> TrackersPack? {
        let packs = loadPacks()
        
        for pack in packs {
            for id in pack.trackerIDList {
                if trackerID == id { return pack }
            }
        }
        return nil
    }
    
    func getPackByCategoryID(_ categoryID: UUID) -> TrackersPack? {
        guard let packCoreData = getPackCoreDataByCategoryID(categoryID) else { return nil }
        return CoreDataMarshalling.map(packCoreData)
    }
    
    func removePack(for categoryID: UUID) {
        guard let packCoreData = getPackCoreDataByCategoryID(categoryID) else { return }
        context.delete(packCoreData)
        savePacks()
    }
    
    private func getPackCoreDataByCategoryID(_ categoryID: UUID) -> TrackersPackCoreData? {
        let request = TrackersPackCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackersPackCoreData.categoryID), categoryID.uuidString)
        
        guard let trackersPacksData = try? context.fetch(request) else { return nil }
        if trackersPacksData.isEmpty { return nil }
        
        return trackersPacksData[0]
    }
    
    private func savePacks() {
        Creator.saveCoreDataContex(context)
    }
    
    private func createManagedObject(from model: TrackersPack) {
        guard let trackerIDListData = CoreDataMarshalling.encode(model.trackerIDList) else { return }
        
        let newTrackerPackCoreData = TrackersPackCoreData(context: context)
        newTrackerPackCoreData.categoryID = model.categoryID
        newTrackerPackCoreData.trackerIDList = trackerIDListData
    }
}
