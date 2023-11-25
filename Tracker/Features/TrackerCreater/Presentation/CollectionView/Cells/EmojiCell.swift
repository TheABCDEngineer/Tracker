import UIKit

final class EmojiCell: UICollectionViewCell {
    static let Identifier = "EmojiCell"

    private var indexPath: IndexPath?
    
    private let label = UILabel()
    
    private var delegate: TrackerCreatorCVCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = UIFont.systemFont(ofSize: 35)
        
        contentView.layer.cornerRadius = 16
        
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCellClick))
        )
        contentView.addSubView(
            label,
            centerX: AnchorOf(contentView.centerXAnchor),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(_ delegate: TrackerCreatorCVCellDelegate) {
        self.delegate = delegate
    }
    
    func setEmoji(_ value: String, indexPath: IndexPath) {
        label.text = value
        self.indexPath = indexPath
    }
    
    func selectCell() {
        delegate?.reloadPreviousSelectedEmojiCell()
        
        if let indexPath {
            delegate?.setSelectedEmojiItem(indexPath)
        }
        contentView.backgroundColor = .ypLightGray
    }
    
    @objc
    private func onCellClick() {
        selectCell()
    }
}
