import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    static let Identifier = "SchedulerHeader"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = Font.ypMedium16
        label.textColor = .ypBlack
        label.backgroundColor = .clear
        
        addSubView(
            label,
            centerX: AnchorOf(centerXAnchor),
            centerY: AnchorOf(centerYAnchor)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
