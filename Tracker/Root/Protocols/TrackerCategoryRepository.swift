import Foundation

protocol TrackerCategoryRepository {
    func createCategory(title: String) -> TrackerCategory
    func getCategoryById(id: UUID) -> TrackerCategory?
    func getCategoryByTitle(title: String) ->TrackerCategory?
    func updateTitle(for categoryID: UUID, newTitle: String) -> TrackerCategory?
    func removeCategory(id: UUID)
    func getCategoryList() -> [TrackerCategory]
}
