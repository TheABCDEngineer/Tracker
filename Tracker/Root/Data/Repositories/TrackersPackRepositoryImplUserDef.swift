import Foundation

final class TrackersPackRepositoryImplUserDef: TrackersPackRepository {
    
    private let repository = UserDefaults.standard
    
    private let key = "trackersPacks"
    
    func loadPacks() -> [TrackersPack] {
        let packs: [TrackersPack] = repository.getJSON(forKey: key) ?? [TrackersPack]()
        return packs
    }
    
    func addTrackerToCategory(trackerID: Int, categoryID: Int) {
        let initPack = getPackByCategory(categoryID)
        var trackerIDList = initPack.trackerIDList
       
        trackerIDList.insert(trackerID)
        
        let requiredPack = TrackersPack(
            categoryID: initPack.categoryID,
            trackerIDList: trackerIDList
        )
        savePack(requiredPack)
    }
    
    func removeTrackerFromCategory(trackerID: Int) {
        let packs = loadPacks()
        if packs.isEmpty { return }
        
        var initPack: TrackersPack?
        for pack in packs {
            if pack.trackerIDList.isEmpty { continue }
            for id in pack.trackerIDList {
                if trackerID == id {
                    initPack = pack
                    break
                }
            }
        }
        guard let initPack else { return }
        
        var trackerIDList = initPack.trackerIDList
       
        trackerIDList.remove(trackerID)
        
        if trackerIDList.isEmpty {
            removePack(for: initPack.categoryID)
            return
        }
        
        let updatedPack = TrackersPack(
            categoryID: initPack.categoryID,
            trackerIDList: trackerIDList
        )
        savePack(updatedPack)
    }
    
    private func getPackByCategory(_ categoryID: Int) -> TrackersPack {
        let packs = loadPacks()
        var requiredPack = TrackersPack(categoryID: categoryID, trackerIDList: [])
        
        if packs.isEmpty { return requiredPack }
        
        for pack in packs {
            if pack.categoryID == categoryID {
                requiredPack = pack
                break
            }
        }
        return requiredPack
    }
    
    private func savePacks(_ packs: [TrackersPack]) {
        repository.setJSON(codable: packs, forKey: key)
    }
    
    private func savePack(_ pack: TrackersPack) {
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
