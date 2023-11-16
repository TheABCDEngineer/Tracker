import Foundation

protocol TrackerCategoryRepository {
    func createCategory(title: String) -> TrackerCategory
    func getCategoryById(id: Int) -> TrackerCategory?
    func getCategoryByTitle(title: String) ->TrackerCategory?
    func updateTitle(for category: TrackerCategory, newTitle: String) -> Bool
    func getCategoryList() -> [TrackerCategory]
}
