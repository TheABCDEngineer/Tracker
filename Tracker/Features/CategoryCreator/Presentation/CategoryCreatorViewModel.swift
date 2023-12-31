import Foundation

final class CategoryCreatorViewModel {
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let applyButtonState = ObservableData<ApplyButton.State>()
    
    private var modifyingCategoryID: UUID?

    init(categoryRepository: TrackerCategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    func setCategoryIDIfModify(_ categoriID: UUID) {
        modifyingCategoryID = categoriID
    }
    
    func observeApplyButtonState(_ completion: @escaping (ApplyButton.State?) -> Void) {
        applyButtonState.observe(completion)
    }
    
    func onUserTextChanged(_ text: String) {
        let value = text.isEmpty ? ApplyButton.inactive : ApplyButton.active
        applyButtonState.postValue(value)
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
