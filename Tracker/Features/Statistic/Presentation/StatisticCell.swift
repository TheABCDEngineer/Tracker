import UIKit

class StatisticCell: UICollectionViewCell {
    
    static let identifier = "StatisticCell"
    
    private let valueLabel = UILabel()
    
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setModel(_ model: StatisticScreenModel) {
        descriptionLabel.text = model.description
        valueLabel.text = model.value
    }

    private func configureCell() {
        let frameImage = UIImageView(image: UIImage(named: "StatisticCardFrame"))
        contentView.addSubView(
            frameImage,
            top: AnchorOf(contentView.topAnchor),
            bottom: AnchorOf(contentView.bottomAnchor),
            leading: AnchorOf(contentView.leadingAnchor),
            trailing: AnchorOf(contentView.trailingAnchor)
        )
        
        valueLabel.font = Font.ypBold34
        valueLabel.textColor = .ypBlack
        valueLabel.text = "0"
        frameImage.addSubView(
            valueLabel,
            top: AnchorOf(frameImage.topAnchor, 12),
            leading: AnchorOf(frameImage.leadingAnchor, 12)
        )
        
        descriptionLabel.font = Font.ypMedium12
        descriptionLabel.textColor = .ypBlack
        frameImage.addSubView(
            descriptionLabel,
            top: AnchorOf(valueLabel.bottomAnchor, 8),
            leading: AnchorOf(valueLabel.leadingAnchor)
        )
    }
}
