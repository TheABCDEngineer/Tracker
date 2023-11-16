import Foundation

final class TrackerCategoryRepositoryImplUserDef: TrackerCategoryRepository {

    static let shared = TrackerCategoryRepositoryImplUserDef()
    
    private let repository = UserDefaults.standard
    
    private let key = "categories"
    
    private var categories: [TrackerCategory]
    
    private var lastId: Int = -1
    
    init() {
        categories = repository.getJSON(forKey: key) ?? [TrackerCategory]()
        if categories.isEmpty { return }
        
        for category in categories {
            if category.id > lastId { lastId = category.id }
        }
    }
    
    func createCategory(title: String) -> TrackerCategory {
        if let category = getCategoryByTitle(title: title) { return category }
        
        lastId += 1
        let newCategory = TrackerCategory(id: lastId, title: title)
        categories.append(newCategory)
        
        saveCategories()
        return newCategory
    }
    
    func getCategoryById(id: Int) -> TrackerCategory? {
        if categories.isEmpty { return nil }
        
        var trackerCategory: TrackerCategory?
        for category in categories {
            if category.id == id {
                trackerCategory = category
                break
            }
        }
        return trackerCategory
    }
    
    func getCategoryByTitle(title: String) -> TrackerCategory? {
        if categories.isEmpty { return nil }
        
        var trackerCategory: TrackerCategory?
        for category in categories {
            if category.title == title {
                trackerCategory = category
                break
            }
        }
        return trackerCategory
    }
    
    func updateTitle(for category: TrackerCategory, newTitle: String) -> Bool {
        if getCategoryById(id: category.id) == nil { return false }
        
        let updatedCategory = TrackerCategory(id: category.id, title: newTitle)
        
        for index in 0 ... categories.count-1 {
            if categories[index].id == category.id {
                categories.insert(updatedCategory, at: index)
                break
            }
        }
        saveCategories()
        return true
    }
    
    func getCategoryList() -> [TrackerCategory] {
        return categories
    }
    
    private func saveCategories() {
        repository.setJSON(codable: categories, forKey: key)
    }
}
