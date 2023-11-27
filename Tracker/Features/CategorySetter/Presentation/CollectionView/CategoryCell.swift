import UIKit

class CategoryCell: SettingsMenuCell {
    static let identifier = "CategoryCell"
    
    private var category: TrackerCategory?
    
    private var cellDelegate: CategorySetterCellDelegate?
    
    private let functionalIcon = UIImageView(image: UIImage(named: "PropertyDone"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        functionalIcon.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setDelegates(
        cellDelegate: CategorySetterCellDelegate,
        contextMenuDelegate: UIContextMenuInteractionDelegate
    ) {
        self.cellDelegate = cellDelegate
        addActionOnCellClick {
            self.check()
            if let category = self.category {
                self.cellDelegate?.setChekedCategory(category)
            }
        }
        
        contentView.addInteraction(
            UIContextMenuInteraction(delegate: contextMenuDelegate)
        )
    }
    
    func setCategory(_ category: TrackerCategory) {
        self.category = category
        label.text = category.title
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
}
