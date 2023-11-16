import Foundation

final class CategoryCreatorPresenter {
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let applyButtonState = ObservableData<ApplyButton.State>()

    init(categoryRepository: TrackerCategoryRepository) {
        self.categoryRepository = categoryRepository
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
        var category = categoryRepository.getCategoryByTitle(title: title)
        if category == nil {
            category = categoryRepository.createCategory(title: title)
        }
        return category
    }
}
