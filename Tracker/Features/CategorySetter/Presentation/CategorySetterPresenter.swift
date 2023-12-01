import Foundation

final class CategorySetterPresenter {
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let trackerPackRepository: TrackersPackRepository
    
    private let screenState = ObservableData<CategorySetterScreen.State>()
    
    init(
        categoryRepository: TrackerCategoryRepository,
        trackerPackRepository: TrackersPackRepository
    ) {
        self.categoryRepository = categoryRepository
        self.trackerPackRepository = trackerPackRepository
    }
    
    func onViewLoaded() {
        if categoryRepository.getCategoryList().isEmpty {
            screenState.postValue(CategorySetterScreen.noEnyCategories)
        } else {
            screenState.postValue(CategorySetterScreen.someCategories)
        }
    }
    
    func getCategoryList() -> [TrackerCategory] {
        return categoryRepository.getCategoryList()
    }
    
    func removeCategory(categoryID: UUID) -> Bool {
        if let pack = trackerPackRepository.getPackByCategoryID(categoryID) {
            if !pack.trackerIDList.isEmpty { return false }
        }
        categoryRepository.removeCategory(id: categoryID)
        trackerPackRepository.removePack(for: categoryID)
        return true
    }
    
    func observeScreenState(_ completion: @escaping (CategorySetterScreen.State?) -> Void) {
        screenState.observe(completion)
    }
}
