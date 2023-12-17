import Foundation

protocol TrackerCreatorCVCellDelegate {
    
    func setSelectedEmojiItem(_ indexPath: IndexPath)
    
    func reloadPreviousSelectedEmojiCell()
    
    func setSelectedColorItem(_ indexPath: IndexPath)
    
    func reloadPreviousSelectedColorCell()
    
    func setTrackerTitle(_ title: String)
    
    func onTrackerCreatingCancel()
    
    func hideKeyboard()
}
