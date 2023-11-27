import UIKit

final class FilterCell: SettingsMenuCell {
    static let identifier = "FilterCell"
    
    private var filterState: FilterState?
    
    private var indexPath: IndexPath?
    
    private var delegate: FilterCellDelegate?
    
    private let functionalIcon = UIImageView(image: UIImage(named: "PropertyDone"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        functionalIcon.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setDelegate(_ delegate: FilterCellDelegate?) {
        self.delegate = delegate
        addActionOnCellClick {
            self.check()
            if let filterState = self.filterState,
               let indexPath = self.indexPath {
                self.delegate?.onFilterChoose(indexPath: indexPath, filter: filterState)
            }
        }
    }
    
    func setFilterState(_ filterState: FilterState) {
        self.filterState = filterState
        label.text = filterState.description()
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    
    func initCell(_ type: SettingsMenuCellType) {
        super.setupCell(type)
        
        contentView.addSubView(
            functionalIcon,
            trailing: AnchorOf(contentView.trailingAnchor, -24),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
    }
    
    func check() {
        functionalIcon.isHidden = false
    }
    
    func unCheck() {
        functionalIcon.isHidden = true
    }
}
