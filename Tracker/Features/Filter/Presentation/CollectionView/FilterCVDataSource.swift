import UIKit

final class FilterCVDataSource: UIViewController {
    
    var cellDelegate: FilterCellDelegate?
    
    var currentFilterState: FilterState = .todayTrackers
    
    var selectedCellIndexPath: IndexPath?
}

extension FilterCVDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        FilterState.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.Identifier, for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        cell.setIndexPath(indexPath)
       
        let filterState = FilterState(rawValue: indexPath.item) ?? FilterState.allTrackers
        cell.setFilterState(filterState)
        
        if filterState == currentFilterState {
            cell.check()
            selectedCellIndexPath = indexPath
        }
        
        switch indexPath.item {
        case 0:
            cell.initCell(.first)
        case FilterState.allCases.count - 1:
            cell.initCell(.last)
        default:
            cell.initCell(.regular)
        }
        
        cell.setDelegate(cellDelegate)
        
        return cell
    }
    
    
}
