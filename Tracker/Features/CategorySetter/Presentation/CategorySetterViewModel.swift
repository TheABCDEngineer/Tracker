import Foundation

final class CategorySetterViewModel {
    
    private let dataProvider: CategoryDataProviderProtocol
    
    private let trackerPackRepository: TrackersPackRepository
    
    private let screenState = ObservableData<CategorySetterScreen.State>()
    
    init(
        trackerPackRepository: TrackersPackRepository,
        dataProvider: CategoryDataProviderProtocol
    ) {
        self.trackerPackRepository = trackerPackRepository
        self.dataProvider = dataProvider
    }
    
    func onViewLoaded() {
        if dataProvider.numberOfItems() == 0 {
            screenState.postValue(CategorySetterScreen.noEnyCategories)
        } else {
            screenState.postValue(CategorySetterScreen.someCategories)
        }
    }
    
    func getCategoriesCount() -> Int {
        return dataProvider.numberOfItems()
    }
    
    func removeCategory(categoryID: UUID) -> Bool {
        if let pack = trackerPackRepository.getPackByCategoryID(categoryID) {
            if !pack.trackerIDList.isEmpty { return false }
        }
        trackerPackRepository.removePack(for: categoryID)
        return true
    }
    
    func observeScreenState(_ completion: @escaping (CategorySetterScreen.State?) -> Void) {
        screenState.observe(completion)
    }
}
