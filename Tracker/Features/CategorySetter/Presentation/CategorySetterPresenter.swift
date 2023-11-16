import Foundation

final class CategorySetterPresenter {
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let screenState = ObservableData<CategorySetterScreen.State>()
    
    init(categoryRepository: TrackerCategoryRepository) {
        self.categoryRepository = categoryRepository
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
    
    func observeScreenState(_ completion: @escaping (CategorySetterScreen.State?) -> Void) {
        screenState.observe(completion)
    }
}
