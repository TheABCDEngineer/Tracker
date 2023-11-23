import UIKit

extension CategorySetterViewController {
    func setupLayout(
        for view: UIView,
        categoryCollection: UICollectionView,
        placeholder: Placeholder,
        addCategoryButton: UIButton
    ) -> UIView {
        let superView = view
        superView.backgroundColor = .ypWhite
        
        categoryCollection.backgroundColor = .clear
        
        superView.addSubView(
            categoryCollection,
            top: AnchorOf(superView.topAnchor),
            bottom: AnchorOf(superView.bottomAnchor),
            leading: AnchorOf(superView.leadingAnchor, 16),
            trailing: AnchorOf(superView.trailingAnchor, -16)
        )
        categoryCollection.showsVerticalScrollIndicator = false
        
        placeholder.image.image = UIImage(named: "TrackerPlaceholder")
        placeholder.label.text = "Привычки и события можно\nобъединить по смыслу"
        superView.addSubView(
            placeholder.view, width: 175, heigth: 125,
            centerX: AnchorOf(superView.centerXAnchor),
            centerY: AnchorOf(superView.centerYAnchor)
        )
        
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.backgroundColor = .ypBlack
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.tintColor = .ypWhite
        addCategoryButton.titleLabel?.font = Font.ypMedium16
        superView.addSubView(
            addCategoryButton, heigth: 60,
            bottom: AnchorOf(superView.bottomAnchor, -50),
            leading: AnchorOf(superView.leadingAnchor, 16),
            trailing: AnchorOf(superView.trailingAnchor, -16)
        )
        
        return superView
    }
}
