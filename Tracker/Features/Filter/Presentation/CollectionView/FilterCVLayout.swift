import UIKit

final class FilterCVLayout {
    static func setup(width: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        //let width = layout.collectionView?.frame.width ?? 100
        
        layout.itemSize = CGSize(width: width, height: 75)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
    }
}
