import UIKit

extension TrackerCreatorViewController {
    func setupLayout(
        for view: UIView,
        eventCreatorCollection: UICollectionView
    ) -> UIView {
        let superView = view
        superView.backgroundColor = .ypWhite
        
        eventCreatorCollection.backgroundColor = .clear
        superView.addSubView(
            eventCreatorCollection,
            top: AnchorOf(superView.topAnchor),
            bottom: AnchorOf(superView.bottomAnchor),
            leading: AnchorOf(superView.leadingAnchor, 16),
            trailing: AnchorOf(superView.trailingAnchor, -16)
        )
        eventCreatorCollection.showsVerticalScrollIndicator = false
        
        return superView
    }
}
