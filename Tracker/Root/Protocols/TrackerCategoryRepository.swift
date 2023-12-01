import Foundation

protocol TrackerCategoryRepository {
    func createCategory(title: String) -> TrackerCategory
    func getCategoryById(id: Int) -> TrackerCategory?
    func getCategoryByTitle(title: String) ->TrackerCategory?
    func updateTitle(for categoryID: Int, newTitle: String) -> TrackerCategory?
    func removeCategory(id: Int)
    func getCategoryList() -> [TrackerCategory]
}
