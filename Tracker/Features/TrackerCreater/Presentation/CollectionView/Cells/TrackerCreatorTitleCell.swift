import UIKit

final class TrackerCreatorTitleCell: UICollectionViewCell {
    static let Identifier = "TitleCell"
    
    let eventLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTitleField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleField() {
        eventLable.backgroundColor = .clear
        eventLable.textColor = .ypBlack
        eventLable.font = Font.ypMedium16
        
        let titleField = UITextField()
        titleField.layer.cornerRadius = 16
        titleField.backgroundColor = .clear
        titleField.textColor = .ypBlack
        titleField.font = Font.ypRegular17
        titleField.placeholder = "Введите название трекера"
        
        let titleFieldBackground = UIView()
        titleFieldBackground.layer.cornerRadius = titleField.layer.cornerRadius
        titleFieldBackground.backgroundColor = .ypLightGray.withAlphaComponent(0.4)
       
        contentView.addSubView(
            eventLable,
            top: AnchorOf(contentView.topAnchor),
            centerX: AnchorOf(contentView.centerXAnchor)
        )
        
        contentView.addSubView(
            titleFieldBackground, heigth: 74,
            top: AnchorOf(eventLable.bottomAnchor, 24),
            leading: AnchorOf(contentView.leadingAnchor),
            trailing: AnchorOf(contentView.trailingAnchor)
        )
        
        titleFieldBackground.addSubView(
            titleField,
            top: AnchorOf(titleFieldBackground.topAnchor),
            bottom: AnchorOf(titleFieldBackground.bottomAnchor),
            leading: AnchorOf(titleFieldBackground.leadingAnchor, 16),
            trailing: AnchorOf(titleFieldBackground.trailingAnchor)
        )
        
        
    }
}
