import UIKit

final class ButtonsCell: UICollectionViewCell {
    static let Identifier = "ButtonsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCancelButton()
        configureApplyButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCancelButton() {
        let cancelButton = UIButton.systemButton(
            with: UIImage(), target: self, action: #selector(onCancelButtonClick)
        )
        
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.titleLabel?.font = Font.ypMedium16
        cancelButton.titleLabel?.tintColor = .ypRed
        
        contentView.addSubView(
            cancelButton,
            width: contentView.frame.width/2 - 4,
            heigth: contentView.frame.height,
            top: AnchorOf(contentView.topAnchor),
            leading: AnchorOf(contentView.leadingAnchor)
        )
    }
    
    private func configureApplyButton() {
        let applyButton = UIButton.systemButton(
            with: UIImage(), target: self, action: #selector(onApplyButtonClick)
        )
        
        applyButton.layer.cornerRadius = 16
        applyButton.backgroundColor = .ypGray
        applyButton.setTitle("Создать", for: .normal)
        applyButton.titleLabel?.font = Font.ypMedium16
        applyButton.titleLabel?.tintColor = .ypWhite
        
        contentView.addSubView(
            applyButton,
            width: contentView.frame.width/2 - 4,
            heigth: contentView.frame.height,
            top: AnchorOf(contentView.topAnchor),
            trailing: AnchorOf(contentView.trailingAnchor)
        )
    }
    
    @objc
    private func onCancelButtonClick() {
        
    }
    
    @objc
    private func onApplyButtonClick() {
        
    }
}
