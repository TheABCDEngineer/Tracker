import UIKit
extension TrackerCreatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 120)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 75)
        case 2:
            return CGSize(width: 52, height: 52)
        case 3:
            return CGSize(width: 52, height: 52)
        case 4:
            return CGSize(width: collectionView.frame.width, height: 60)
        default:
            return CGSize(width: 52, height: 52)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int)
    -> CGFloat {
        switch section {
        case 0, 1, 4:
            return 0
        case 2:
            return 0
        case 3:
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        switch section {
        case 0, 1, 4:
            return 0
        case 2:
            return 4
        case 3:
            return 4
        default:
            return 4
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        switch section {
        case 0, 1, 4:
            return CGSize(width: collectionView.frame.width, height: 24)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 80)
        case 3:
            return CGSize(width: collectionView.frame.width, height: 80)
        default:
            return CGSize()
        }
    }
}
