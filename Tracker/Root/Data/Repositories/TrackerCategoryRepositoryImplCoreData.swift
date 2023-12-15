import Foundation
import CoreData

final class TrackerCategoryRepositoryImplCoreData: TrackerCategoryRepository {
    
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext
    ) {
        self.context = context
    }
    
    func createCategory(title: String) -> TrackerCategory {
        if let category = getCategoryByTitle(title: title) { return category }
        
        let newCategory = TrackerCategory(id: UUID(), title: title)
        createManagedObject(from: newCategory)
        saveCategories()
        
        return newCategory
    }
    
    func getCategoryById(id: UUID) -> TrackerCategory? {
        guard let categoryCoreData = getCategoryCoreDataByID(id) else { return nil }
        return CoreDataMarshalling.map(categoryCoreData)
    }
    
    func getCategoryByTitle(title: String) -> TrackerCategory? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        
        guard let categoriesData = try? context.fetch(request) else { return nil }
        if categoriesData.isEmpty { return nil }
        
        return CoreDataMarshalling.map(categoriesData[0])
    }
    
    func updateTitle(for categoryID: UUID, newTitle: String) -> TrackerCategory? {
        guard let categoryCoreData = getCategoryCoreDataByID(categoryID) else { return nil }
        categoryCoreData.title = newTitle
        saveCategories()
        return CoreDataMarshalling.map(categoryCoreData)
    }
    
    func removeCategory(id: UUID) {
        guard let categoryCoreData = getCategoryCoreDataByID(id) else { return }
        context.delete(categoryCoreData)
        saveCategories()
    }
    
    func getCategoryList() -> [TrackerCategory] {
        loadCategories()
    }
    
    private func getCategoryCoreDataByID(_ id: UUID) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.id_), id.uuidString)
        
        guard let categoriesData = try? context.fetch(request) else { return nil }
        if categoriesData.isEmpty { return nil }
        
        return categoriesData[0]
    }
    
    private func saveCategories() {
        Creator.saveCoreDataContex(context)
    }
    
    
    private func loadCategories() -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        guard let categoriesData = try? context.fetch(request) else { return [TrackerCategory]() }
        
        return categoriesData.compactMap({CoreDataMarshalling.map($0)})
    }
    
    private func createManagedObject(from model: TrackerCategory) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.id_ = model.id
        trackerCategoryCoreData.title = model.title
    }
}
