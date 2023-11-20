import UIKit

final class ButtonsCell: UICollectionViewCell {
    static let Identifier = "ButtonsCell"
    
    private var applyButton: UIButton?
    
    private var delegate: TrackerCreatorCVCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCancelButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        applyButton?.removeFromSuperview()
    }
    
    func setDelegate(_ delegate: TrackerCreatorCVCellDelegate) {
        self.delegate = delegate
    }
    
    func setApplyButton(_ button: UIButton) {
        self.applyButton = button
    }
    
    func initCell() {
        configureApplyButton()
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
        guard let applyButton else { return }
        
        applyButton.layer.cornerRadius = 16
        applyButton.backgroundColor = ApplyButton.inactive.color
        applyButton.setTitle("Создать", for: .normal)
        applyButton.titleLabel?.font = Font.ypMedium16
        applyButton.tintColor = .ypWhite
        applyButton.isUserInteractionEnabled = ApplyButton.inactive.isEnabled
        
        
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
        delegate?.onTrackerCreatingCancel()
    }
}
