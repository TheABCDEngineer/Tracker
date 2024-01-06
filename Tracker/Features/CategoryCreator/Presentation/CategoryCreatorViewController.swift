import UIKit

class CategoryCreatorViewController: UIViewController {
    
    private let viewModel = Creator.injectCategoryCreatorViewModel()
    
    private var moodifyingCategoryTitle = ""
    
    private let applyButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onApplyButtonClick)
    )
    
    private let categoryField = UITextField()
    
    private var onCreateCategoryRequest: ( (String) -> Void )?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryField.delegate = self
        categoryField.text = moodifyingCategoryTitle
        
        let pageTitle = moodifyingCategoryTitle.isEmpty
            ? localized("new category")
            : localized("edit category")
        
        self.view = setupLayout(
            for: self.view,
            applyButton: applyButton,
            categoryField: categoryField,
            pageTitle: pageTitle
        )
        viewModel.observeApplyButtonState { [weak self] state in
            guard let self, let state else { return }
            self.updateApplyButtonState(state)
        }
        categoryField.addTarget(nil,
            action: #selector(onCategoryFieldTextChange),
            for: .allEvents
        )
    }
    
    func setCategoryIfModify(_ category: TrackerCategory?) {
        guard let category else { return }
        moodifyingCategoryTitle = category.title
        viewModel.setCategoryIDIfModify(category.id)
    }
    
    func onCreateCategoryRequest(_ completion: @escaping (String) -> Void) {
        self.onCreateCategoryRequest = completion
    }
    
    private func updateApplyButtonState(_ state: ApplyButton.State) {
        applyButton.isUserInteractionEnabled = state.isEnabled
        applyButton.backgroundColor = state.color
    }
    
    @objc
    private func onApplyButtonClick() {
        guard let title = categoryField.text,
              let onCreateCategoryRequest
        else { return }
        
        dismiss(animated: false)
        onCreateCategoryRequest(title)
    }
    
    @objc
    private func onCategoryFieldTextChange() {
        guard let text = categoryField.text else { return }
        viewModel.onUserTextChanged(text)
    }
}

//MARK: - UITextFieldDelegate
extension CategoryCreatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
