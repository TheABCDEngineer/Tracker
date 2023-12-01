import UIKit

class ColorsCell: UICollectionViewCell {
    static let identifier = "ColorsCell"
    
    private let view = UIView()

    private var indexPath: IndexPath?
    
    private var delegate: TrackerCreatorCVCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        view.layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCellClick))
        )
        contentView.addSubView(
            view, width: 40, heigth: 40,
            centerX: AnchorOf(contentView.centerXAnchor),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.borderWidth = 0
    }
    
    func setDelegate(_ delegate: TrackerCreatorCVCellDelegate) {
        self.delegate = delegate
    }
    
    func setColor(_ value: TrackerColor, indexPath: IndexPath) {
        view.backgroundColor = value.toUIColor()
        contentView.layer.borderColor = value.toUIColor().withAlphaComponent(0.3).cgColor
        
        self.indexPath = indexPath
    }
    
    func selectCell() {
        delegate?.reloadPreviousSelectedColorCell()
        
        if let indexPath {
            delegate?.setSelectedColorItem(indexPath)
        }
        contentView.layer.borderWidth = 4
    }
    
    @objc
    private func onCellClick() {
        selectCell()
    }
    
}
