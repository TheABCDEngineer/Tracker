import UIKit

final class SectionTitleHeaderView: UICollectionReusableView {
    static let Identifier = "Header"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = Font.ypBold19
        label.textColor = .ypBlack
        label.backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        label.removeFromSuperview()
    }
    
    func configureLablePosition(x: CGFloat, y: CGFloat) {
        addSubView(
            label,
            top: AnchorOf(topAnchor, y),
            leading: AnchorOf(leadingAnchor, x)
        )
    }
}
