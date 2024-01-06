import UIKit

final class StatisticViewController: UIViewController {
    
    private let viewModel = Creator.injectStatisticViewModel()
    
    private let placeholder = Placeholder()
    
    private var statisticCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        configureTableView()
        configureLayout()
        setObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewLoaded()
    }
    
    private func configureTableView() {
        statisticCV = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureFlowLayout()
        )
        statisticCV.dataSource = self
        statisticCV.register(StatisticCell.self, forCellWithReuseIdentifier: StatisticCell.identifier)
        
    }
    
    private func configureFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width - 32, height: 90)
        layout.minimumLineSpacing = 12
        return layout
    }
    
    private func setObservers() {
        viewModel.observePlaceholderState { [weak self] isHidden in
            guard let self else { return }
            self.placeholder.view.isHidden = isHidden
            self.statisticCV.isHidden = !self.placeholder.view.isHidden
        }
        
        viewModel.observeStatisticUpdated { [weak self] in
            guard let self else { return }
            self.statisticCV.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension StatisticViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.itemsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell else { return UICollectionViewCell() }
    
        cell.setModel(viewModel.object(for: indexPath))
        return cell
    }
}

//MARK: - configure layout
extension StatisticViewController {
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
        
        statisticCV.backgroundColor = .clear
        view.addSubView(
            statisticCV,
            top: AnchorOf(statisticLabel.bottomAnchor, 70),
            bottom: AnchorOf(view.bottomAnchor),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
    }
}
