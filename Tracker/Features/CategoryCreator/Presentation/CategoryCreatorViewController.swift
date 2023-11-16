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
        configureLayout()
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
    
    private func configureLayout() {
        view.backgroundColor = .ypWhite
        
        categoryField.layer.cornerRadius = 16
        categoryField.backgroundColor = .clear
        categoryField.textColor = .ypBlack
        categoryField.font = Font.ypRegular17
        categoryField.placeholder = "Введите название категории"
        
        let categoryFieldBackground = UIView()
        categoryFieldBackground.layer.cornerRadius = categoryField.layer.cornerRadius
        categoryFieldBackground.backgroundColor = .ypLightGray.withAlphaComponent(0.4)
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = Font.ypMedium16
        label.textColor = .ypBlack
        label.text = "Новая категория"
        
        view.addSubView(
            label,
            top: AnchorOf(view.topAnchor, 32),
            centerX: AnchorOf(view.centerXAnchor)
        )
   
        view.addSubView(
            categoryFieldBackground, heigth: 74,
            top: AnchorOf(label.bottomAnchor, 38),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
        
        categoryFieldBackground.addSubView(
            categoryField,
            top: AnchorOf(categoryFieldBackground.topAnchor),
            bottom: AnchorOf(categoryFieldBackground.bottomAnchor),
            leading: AnchorOf(categoryFieldBackground.leadingAnchor, 16),
            trailing: AnchorOf(categoryFieldBackground.trailingAnchor)
        )
        
        applyButton.layer.cornerRadius = 16
        applyButton.setTitle("Готово", for: .normal)
        applyButton.titleLabel?.font = Font.ypMedium16
        applyButton.tintColor = .ypWhite
        applyButton.backgroundColor = ApplyButton.inactive.color
        applyButton.isUserInteractionEnabled = ApplyButton.inactive.isEnabled
        
        view.addSubView(
            applyButton, heigth: 60,
            bottom: AnchorOf(view.bottomAnchor, -50),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
    }
}
