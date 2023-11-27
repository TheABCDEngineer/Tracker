import UIKit

class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    private var indexPath: IndexPath?
    
    private var cellDelegate: TrackersCVCellDelegate?
    
    private let trackerCard = UIView()
    
    private let title = UILabel()
    
    private let emoji = UILabel()
    
    private let daysCounter = UILabel()
    
    private let checkButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onCheckButtonClick)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegates(
        cellDelegate: TrackersCVCellDelegate,
        contextMenuDelegate: UIContextMenuInteractionDelegate
    ) {
        self.cellDelegate = cellDelegate
        
        trackerCard.addInteraction(
            UIContextMenuInteraction(delegate: contextMenuDelegate)
        )
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func setModel(_ model: TrackerScreenModel) {
        trackerCard.backgroundColor = model.color
        
        checkButton.backgroundColor = model.isAvailable ? model.color : model.color.withAlphaComponent(0.3)
        
        let checkButtonImage = model.isCompleted ? UIImage(named: "PropertyDone") : UIImage(named: "Add Tracker")
        
        checkButton.setImage(
            checkButtonImage,
            for: .normal
        )
        checkButton.isUserInteractionEnabled = model.isAvailable
        
        title.text = model.title
        emoji.text = model.emoji
        daysCounter.text = getDaysString(model.daysCount)
    }
    
    private func configureCell() {
        trackerCard.layer.cornerRadius = 16

        contentView.addSubView(
            trackerCard, heigth: 90,
            top: AnchorOf(contentView.topAnchor),
            leading: AnchorOf(contentView.leadingAnchor),
            trailing: AnchorOf(contentView.trailingAnchor)
        )
        
        let emojiBackground = UIView()
        emojiBackground.frame.size = CGSize(width: 28, height: 28)
        emojiBackground.layer.masksToBounds = true
        emojiBackground.layer.cornerRadius = emojiBackground.frame.width/2
        emojiBackground.backgroundColor = .ypBackground
        
        trackerCard.addSubView(
            emojiBackground,
            width: emojiBackground.frame.width,
            heigth: emojiBackground.frame.height,
            top: AnchorOf(trackerCard.topAnchor, 12),
            leading: AnchorOf(trackerCard.leadingAnchor, 12)
        )
        
        emoji.textAlignment = .center
        emoji.font = Font.ypMedium16
        emoji.backgroundColor = .clear
        
        emojiBackground.addSubView(
            emoji,
            centerX: AnchorOf(emojiBackground.centerXAnchor),
            centerY: AnchorOf(emojiBackground.centerYAnchor)
        )
        
        title.font = Font.ypMedium12
        title.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        title.backgroundColor = .clear
        title.textAlignment = .left
        
        trackerCard.addSubView(
            title,
            top: AnchorOf(emojiBackground.bottomAnchor, 0),
            bottom: AnchorOf(trackerCard.bottomAnchor, -12),
            leading: AnchorOf(trackerCard.leadingAnchor, 12),
            trailing: AnchorOf(trackerCard.trailingAnchor, -12)
        )
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        title.adjustsFontSizeToFitWidth = false
        
        checkButton.frame.size = CGSize(width: 34, height: 34)
        checkButton.layer.cornerRadius = checkButton.frame.width/2
        checkButton.tintColor = .ypWhite
        
        
        contentView.addSubView(
            checkButton, width: 34, heigth: 34,
            top:  AnchorOf(trackerCard.bottomAnchor, 12),
            trailing: AnchorOf(contentView.trailingAnchor, -12)
        )
        
        daysCounter.font = Font.ypMedium12
        daysCounter.textColor = .ypBlack
        daysCounter.textAlignment = .left
        
        contentView.addSubView(
            daysCounter,
            leading: AnchorOf(contentView.leadingAnchor, 12),
            trailing: AnchorOf(checkButton.leadingAnchor, -8),
            centerY: AnchorOf(checkButton.centerYAnchor)
        )
    }
    
    private func getDaysString(_ days: Int) -> String {
        var daysDeclension = "дней"
        guard let lastTwoDigitNumder = days < 100 ? days : Int(String(days).suffix(2)) else {
            return "\(days) \(daysDeclension)"
        }
        
        if lastTwoDigitNumder < 5 || lastTwoDigitNumder > 20 {
            guard let lastDigit = Int(String(days).suffix(1)) else {
                return "\(days) \(daysDeclension)"
            }
            switch lastDigit {
            case 1:
                daysDeclension = "день"
            case 2, 3, 4:
                daysDeclension = "дня"
            default:
               break
            }
        }
        return "\(days) \(daysDeclension)"
    }
    
    @objc
    private func onCheckButtonClick() {
        guard let indexPath else { return }
        cellDelegate?.onTrackerChecked(for: indexPath)
    }
}
