import Foundation

protocol CategoryDataProviderDelegate {
    func update(
        handleType: ItemHandleType,
        indexPath: IndexPath,
        indexPathForReconfigure: IndexPath?,
        reconfiguredCellType: SettingsMenuCellType
    )
}
