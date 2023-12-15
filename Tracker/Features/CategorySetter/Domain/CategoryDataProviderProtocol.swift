import Foundation

protocol CategoryDataProviderProtocol {
    func setDelegate(_ delegate: CategoryDataProviderDelegate)
    func numberOfItems() -> Int
    func object(at indexPath: IndexPath) -> TrackerCategory?
    func addCategory(title: String ) -> TrackerCategory
    func removeCategory(at indexPath: IndexPath) -> Bool
}
