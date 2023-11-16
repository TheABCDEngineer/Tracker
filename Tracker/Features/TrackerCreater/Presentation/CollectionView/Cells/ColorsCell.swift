import UIKit

class ColorsCell: UICollectionViewCell {
    static let Identifier = "ColorsCell"
    
    private let view = UIView()
    
    private var color: TrackerColor?
    
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
        self.color = value
        guard let background = color?.toUIColor() else { return }
        view.backgroundColor = background
        
        self.indexPath = indexPath
    }
    
    @objc
    private func onCellClick() {
        delegate?.reloadPreviousSelectedColorCell()
        
        if let indexPath {
            delegate?.setSelectedColorItem(indexPath)
        }
        contentView.layer.borderWidth = 4
        contentView.layer.borderColor = color?.toUIColor().withAlphaComponent(0.3).cgColor
    }
    
}
