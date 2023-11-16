import UIKit

class SchedulerButtonsCell: UICollectionViewCell {
    static let Identifier = "SchedulerButtonsCell"
    
    private var applyButton: UIButton?
    
    private var delegate: TrackerCreatorCVCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func configureApplyButton() {
        guard let applyButton else { return }
        
        applyButton.layer.cornerRadius = 16
        applyButton.setTitle("Создать", for: .normal)
        applyButton.titleLabel?.font = Font.ypMedium16
        applyButton.tintColor = .ypWhite
        
        
        contentView.addSubView(
            applyButton, heigth: 60,
            bottom: AnchorOf(contentView.bottomAnchor),
            leading: AnchorOf(contentView.leadingAnchor, 4),
            trailing: AnchorOf(contentView.trailingAnchor, -4)
        )
    }
}
