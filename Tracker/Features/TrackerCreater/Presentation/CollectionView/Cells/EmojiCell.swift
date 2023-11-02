import UIKit

final class EmojiCell: UICollectionViewCell {
    static let Identifier = "EmojiCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = UIFont.systemFont(ofSize: 35)
        
        contentView.addSubView(
            label,
            centerX: AnchorOf(contentView.centerXAnchor),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
