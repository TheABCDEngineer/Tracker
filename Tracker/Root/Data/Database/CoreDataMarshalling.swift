import Foundation
import CoreData

final class CoreDataMarshalling {
    static func map(_ dto: TrackerCoreData) -> TrackerModel? {
        guard let id = dto.id_,
              let typeData = dto.type,
              let title = dto.title,
              let scheduleData = dto.schedule,
              let emoji = dto.emoji,
              let colorData = dto.color
        else { return nil }
       
        guard let type = try? JSONDecoder().decode(TrackerType.self, from: typeData),
              let schedule = try? JSONDecoder().decode(Set<WeekDays>.self, from: scheduleData),
              let color = try? JSONDecoder().decode(TrackerColor.self, from: colorData)
        else { return nil }
        
        return TrackerModel(
            id: id,
            type: type,
            title: title,
            schedule: schedule,
            emoji: emoji,
            color: color
        )
    }
    
    static func map(_ dto: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let id = dto.id_,
              let title = dto.title
        else { return nil }
        
        return TrackerCategory(id: id, title: title)
    }
    
    static func map(_ dto: TrackersPackCoreData) -> TrackersPack? {
        guard let trackerIDListData = dto.trackerIDList else { return nil }
        
        guard let categoryID = dto.categoryID,
              let trackerIDList =
                try? JSONDecoder().decode(Set<UUID>.self, from: trackerIDListData as Data) else { return nil }
        
        return TrackersPack(categoryID: categoryID, trackerIDList: trackerIDList)
    }
    
    static func map(_ dto: TrackerRecordCoreData) -> TrackerRecord? {
        guard let datesData = dto.dates else { return nil }
        
        guard let trackerID = dto.trackerID,
              let dates = try? JSONDecoder().decode(Set<Int>.self, from: datesData as Data) else { return nil }
        
        return TrackerRecord(trackerID: trackerID, dates: dates)
    }
    
    static func encode<T:Codable>(_ property: T?) -> Data? {
        if property == nil { return nil }
        return try? JSONEncoder().encode(property)
    }
}
