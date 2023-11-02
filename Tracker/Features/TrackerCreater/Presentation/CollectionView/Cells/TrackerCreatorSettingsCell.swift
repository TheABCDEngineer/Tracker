import UIKit

final class TrackerCreatorSettingsCell: SettingsMenuCell {
    static let Identifier = "SettingsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell(_ type: SettingsMenuCellType) {
        super.subLabelIndent = 4
        
        super.setupCell(type)
        
        let functionalIcon = UIImageView(image: UIImage(named: "FunctionalIcon1"))
        
        contentView.addSubView(
            functionalIcon,
            trailing: AnchorOf(contentView.trailingAnchor, -24),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
    }
    
}
