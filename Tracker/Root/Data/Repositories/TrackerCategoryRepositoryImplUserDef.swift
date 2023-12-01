import Foundation

final class TrackerCategoryRepositoryImplUserDef: TrackerCategoryRepository {
    
    private let repository = UserDefaults.standard
    
    private let key = "categories"
        
    func createCategory(title: String) -> TrackerCategory {
        if let category = getCategoryByTitle(title: title) { return category }
        
        let newCategory = TrackerCategory(id: UUID(), title: title)

        saveCategory(newCategory)
        return newCategory
    }
    
    func getCategoryById(id: UUID) -> TrackerCategory? {
        let categories = loadCategories()
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
        let categories = loadCategories()
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
    
    func updateTitle(for categoryID: UUID, newTitle: String) -> TrackerCategory? {
        if getCategoryById(id: categoryID) == nil { return nil }
        
        let updatedCategory = TrackerCategory(id: categoryID, title: newTitle)
        
        var categories = loadCategories()
        for index in 0 ... categories.count-1 {
            if categories[index].id == categoryID {
                categories[index] = updatedCategory
                break
            }
        }
        saveCategories(categories)
        return updatedCategory
    }
    
    func removeCategory(id: UUID) {
        var categories = loadCategories()
        for index in 0 ... categories.count-1 {
            if categories[index].id == id {
                categories.remove(at: index)
                saveCategories(categories)
                break
            }
        }
    }
    
    func getCategoryList() -> [TrackerCategory] {
        return loadCategories()
    }
    
    private func saveCategories(_ categories: [TrackerCategory]) {
        repository.setJSON(codable: categories, forKey: key)
    }
    
    private func saveCategory(_ category: TrackerCategory) {
        var categories = loadCategories()
        categories.append(category)
        saveCategories(categories)
    }
    
    private func loadCategories() -> [TrackerCategory] {
        return repository.getJSON(forKey: key) ?? [TrackerCategory]()
    }
}
