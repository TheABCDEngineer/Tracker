import UIKit

extension SchedulerViewController {
    func setupLayout(
        for view: UIView,
        schedulerCollection: UICollectionView,
        applyButton: UIButton
    ) -> UIView {
        let superView = view
        superView.backgroundColor = .ypWhite
    
        schedulerCollection.backgroundColor = .clear
        
        superView.addSubView(
            schedulerCollection,
            top: AnchorOf(superView.topAnchor),
            bottom: AnchorOf(superView.bottomAnchor),
            leading: AnchorOf(superView.leadingAnchor, 16),
            trailing: AnchorOf(superView.trailingAnchor, -16)
        )
        schedulerCollection.showsVerticalScrollIndicator = false
        
        return superView
    }
}
