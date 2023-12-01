import UIKit

extension CategoryCreatorViewController {
    func setupLayout(
        for view: UIView,
        applyButton: UIButton,
        categoryField: UITextField,
        pageTitle: String
    ) -> UIView {
        let superView = view
        superView.backgroundColor = .ypWhite
        
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
        label.text = pageTitle//"Новая категория"
        
        superView.addSubView(
            label,
            top: AnchorOf(superView.topAnchor, 32),
            centerX: AnchorOf(superView.centerXAnchor)
        )
   
        superView.addSubView(
            categoryFieldBackground, heigth: 74,
            top: AnchorOf(label.bottomAnchor, 38),
            leading: AnchorOf(superView.leadingAnchor, 16),
            trailing: AnchorOf(superView.trailingAnchor, -16)
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
        
        superView.addSubView(
            applyButton, heigth: 60,
            bottom: AnchorOf(superView.bottomAnchor, -50),
            leading: AnchorOf(superView.leadingAnchor, 16),
            trailing: AnchorOf(superView.trailingAnchor, -16)
        )

        return superView
    }
}
