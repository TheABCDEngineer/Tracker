import UIKit

class ColorsCell: UICollectionViewCell {
    static let Identifier = "ColorsCell"
    
    let view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        
        view.layer.cornerRadius = 8
        
        contentView.addSubView(
            view, width: 40, heigth: 40,
            centerX: AnchorOf(contentView.centerXAnchor),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
