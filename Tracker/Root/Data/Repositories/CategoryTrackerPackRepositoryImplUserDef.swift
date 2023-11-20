import Foundation

final class CategoryTrackerPackRepositoryImplUserDef: CategoryTrackerPackRepository {
    
    private let repository = UserDefaults.standard
    
    private let key = "trackersPacks"
    
    func loadPacks() -> [CategoryTrackerPack] {
        let packs: [CategoryTrackerPack] = repository.getJSON(forKey: key) ?? [CategoryTrackerPack]()
        return packs
    }
    
    func addTrackerToCategory(with tracker: TrackerModel, to category: TrackerCategory) {
        let initPack = getPackByCategory(category.id)
        var trackerIDList = initPack.trackerIDList
       
        trackerIDList.insert(tracker.id)
        
        let requiredPack = CategoryTrackerPack(
            categoryID: initPack.categoryID,
            trackerIDList: trackerIDList
        )
        savePack(requiredPack)
    }
    
    func removeTrackerFromCategory(with tracker: TrackerModel, from category: TrackerCategory) {
        let initPack = getPackByCategory(category.id)
        var trackerIDList = initPack.trackerIDList
       
        trackerIDList.remove(tracker.id)
        
        if trackerIDList.isEmpty {
            removePack(for: initPack.categoryID)
            return
        }
        
        let requiredPack = CategoryTrackerPack(
            categoryID: initPack.categoryID,
            trackerIDList: trackerIDList
        )
        savePack(requiredPack)
    }
    
    private func getPackByCategory(_ categoryID: Int) -> CategoryTrackerPack {
        let packs = loadPacks()
        var requiredPack = CategoryTrackerPack(categoryID: categoryID, trackerIDList: [])
        
        if packs.isEmpty { return requiredPack }
        
        for pack in packs {
            if pack.categoryID == categoryID {
                requiredPack = pack
                break
            }
        }
        return requiredPack
    }
    
    private func savePacks(_ packs: [CategoryTrackerPack]) {
        repository.setJSON(codable: packs, forKey: key)
    }
    
    private func savePack(_ pack: CategoryTrackerPack) {
        var packs = loadPacks()
        
        if packs.isEmpty {
            packs.append(pack)
            savePacks(packs)
            return
        }
        
        var isNewPack = true
        for index in 0 ... packs.count - 1 {
            if packs[index].categoryID == pack.categoryID {
                packs[index] = pack
                isNewPack = false
                break
            }
        }
        if isNewPack { packs.append(pack) }
        savePacks(packs)
    }
    
    private func removePack(for categoryID: Int) {
        var packs = loadPacks()
        if packs.isEmpty { return }
        
        for index in 0 ... packs.count - 1 {
            if packs[index].categoryID == categoryID {
                packs.remove(at: index)
                savePacks(packs)
                break
            }
        }
    }
}
