import UIKit

final class StatisticViewController: UIViewController {
    private let placeholder = Placeholder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        configureLayout()
    }
    
    private func configureLayout() {

        let statisticLabel = UILabel()
        statisticLabel.backgroundColor = .clear
        statisticLabel.text = localized("statistic")
        statisticLabel.textColor = .ypBlack
        statisticLabel.font = Font.ypBold34
        view.addSubView(
            statisticLabel,
            top: AnchorOf(view.topAnchor, 88),
            leading: AnchorOf(view.leadingAnchor, 16)
        )
        
        placeholder.image.image = UIImage(named: "StatisticPlaceholder")
        placeholder.label.text = localized("statistic.placeholder")
        view.addSubView(
            placeholder.view, width: 175, heigth: 125,
            centerX: AnchorOf(view.centerXAnchor),
            centerY: AnchorOf(view.centerYAnchor)
        )
    }
}
