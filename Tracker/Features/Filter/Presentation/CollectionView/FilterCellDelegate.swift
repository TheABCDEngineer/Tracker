import Foundation

protocol FilterCellDelegate {
    func onFilterChoose(indexPath: IndexPath, filter: FilterState)
}
