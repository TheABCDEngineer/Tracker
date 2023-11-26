import UIKit

class CategoryCreatorViewController: UIViewController {
    
    private let presenter = Creator.injectCategoryCreatorPresenter()
    
    private var moodifyingCategoryTitle = ""
    
    private let applyButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onApplyButtonClick)
    )
    
    private let categoryField = UITextField()
    
    private var onCategoryCreated: ( (TrackerCategory) -> Void )?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryField.text = moodifyingCategoryTitle
        
        let pageTitle = moodifyingCategoryTitle.isEmpty
            ? "Новая категория"
            : "Редактирование категории"
        
        self.view = setupLayout(
            for: self.view,
            applyButton: applyButton,
            categoryField: categoryField,
            pageTitle: pageTitle
        )
        presenter.observeApplyButtonState { [weak self] state in
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
        presenter.setCategoryIDIfModify(category.id)
    }
    
    func onCategoryCreated(_ completion: @escaping (TrackerCategory) -> Void) {
        self.onCategoryCreated = completion
    }
    
    private func updateApplyButtonState(_ state: ApplyButton.State) {
        applyButton.isUserInteractionEnabled = state.isEnabled
        applyButton.backgroundColor = state.color
    }
    
    @objc
    private func onApplyButtonClick() {
        guard let title = categoryField.text else { return }
        guard let category = presenter.createCategory(title) else { return }
        guard let onCategoryCreated else { return }
        
        dismiss(animated: false)
        onCategoryCreated(category)
    }
    
    @objc
    private func onCategoryFieldTextChange() {
        guard let text = categoryField.text else { return }
        presenter.onUserTextChanged(text)
    }
}
