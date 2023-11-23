import UIKit

class CategoryCreatorViewController: UIViewController {
    
    private let presenter = Creator.injectCategoryCreatorPresenter()
    
    private let applyButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onApplyButtonClick)
    )
    
    private let categoryField = UITextField()
    
    private var onCategoryCreated: ( (TrackerCategory) -> Void )?

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view = setupLayout(
            for: self.view,
            applyButton: applyButton,
            categoryField: categoryField
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
