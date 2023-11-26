import Foundation

final class CategoryCreatorPresenter {
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let applyButtonState = ObservableData<ApplyButton.State>()
    
    private var modifyingCategoryID: Int?

    init(categoryRepository: TrackerCategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func setCategoryIDIfModify(_ categoriID: Int) {
        modifyingCategoryID = categoriID
    }
    
    func observeApplyButtonState(_ completion: @escaping (ApplyButton.State?) -> Void) {
        applyButtonState.observe(completion)
    }
    
    func onUserTextChanged(_ text: String) {
        if text.isEmpty {
            applyButtonState.postValue(ApplyButton.inactive)
        } else {
            applyButtonState.postValue(ApplyButton.active)
        }
    }
    
    func createCategory(_ title: String) -> TrackerCategory? {
        if let categoryID = modifyingCategoryID {
            return categoryRepository.updateTitle(for: categoryID, newTitle: title)
        }
        
        var category = categoryRepository.getCategoryByTitle(title: title)
        if category == nil {
            category = categoryRepository.createCategory(title: title)
        }
        return category
    }
}
