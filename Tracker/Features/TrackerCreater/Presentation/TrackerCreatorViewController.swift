import UIKit

final class TrackerCreatorViewController: UIViewController {
    var trackerType: TrackerType = .event
    
    private let presenter = Creator.injectTrackerCreatorPresenter()
    
    private var eventCreatorCollection: UICollectionView!
        
    private let applyButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onApplyButtonClick)
    )
    
    private var currentSelectedEmojiIndexPath: IndexPath?
    
    private var currentSelectedColorIndexPath: IndexPath?
    
    private var scheduleIndexPath: IndexPath?
    
    private var categoryIndexPath: IndexPath?
    
    private var titleFieldIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureLayout()
        setObservers()
        configureCreatorCollectionView()
    }
    
    private func setObservers() {
        presenter.observeAllPropertiesDidEnter { [weak self] state in
            guard let self, let state else { return }
            self.updateApplyButtonState(state)
        }
        
        presenter.observeScheduleCreated { [weak self] scheduleString in
            guard let self, let scheduleString else { return }
            self.updateSublabelInSettingCell(for: scheduleIndexPath, text: scheduleString)
        }
        
        presenter.observeCategoryCreated { [weak self] categoryTitle in
            guard let self, let categoryTitle else { return }
            self.updateSublabelInSettingCell(for: categoryIndexPath, text: categoryTitle)
        }
    }
    
    private func updateApplyButtonState(_ state: ApplyButton.State) {
        applyButton.isUserInteractionEnabled = state.isEnabled
        applyButton.backgroundColor = state.color
    }
        
    private func updateSublabelInSettingCell(for indexPath: IndexPath?, text: String) {
        guard let indexPath else { return }
        guard let cell = eventCreatorCollection.cellForItem(at: indexPath) as? TrackerCreatorSettingsCell else { return }
        cell.subLabel.text = text
        cell.updateLabels()
    }
    
    private func unfocusedTileField() {
        guard let titleFieldIndexPath else { return }
        guard let cell = eventCreatorCollection.cellForItem(at: titleFieldIndexPath) as? TrackerCreatorTitleCell else { return }
        cell.unfocused()
    }
    
    private func launchScheduler() {
        let controller = SchedulerViewController()
        controller.onSetSchedule { [weak self] schedule in
            guard let self else { return }
            presenter.setSchedule(schedule)
        }
        controller.setCurrentSchedule(presenter.schedule)
        unfocusedTileField()
        self.present(controller, animated: true)
    }
    
    private func launchCategorySelector() {
        let controller = CategorySetterViewController()
        controller.onSetCategory {[weak self] category in
            guard let self else { return }
            presenter.setCategory(category)
        }
        controller.setInitCategory(presenter.category)
        unfocusedTileField()
        self.present(controller, animated: true)
    }
    
    @objc
    private func onApplyButtonClick() {
        presenter.createTracker()
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension TrackerCreatorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return trackerType == .habit ? 2 : 1
        case 2:
            return TrackerEmoji.items.count
        case 3:
            return TrackerColors.items.count
        case 4:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            return configureTitleCell(for: collectionView, with: indexPath)
        case 1:
            return configureSettingsCell(for: collectionView, with: indexPath)
        case 2:
            return configureEmojiCell(for: collectionView, with: indexPath)
        case 3:
            return configureColorsCell(for: collectionView, with: indexPath)
        case 4:
            return configureButtonsCell(for: collectionView, with: indexPath)
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch indexPath.section {
        case 0, 1, 4:
            return configureHeader(collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        case 2:
            return configureHeader(title: "Emoji", x: 6, y: 40, collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        case 3:
            return configureHeader(title: "Цвет", x: 6, y: 40, collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        default:
            return UICollectionReusableView()
        }
       
    }

    private func configureTitleCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TrackerCreatorTitleCell.Identifier,
                            for: indexPath
                ) as? TrackerCreatorTitleCell else {
                    return UICollectionViewCell()
                }
        titleFieldIndexPath = indexPath
        cell.eventLable.text = trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        cell.setDelegate(self)
        return cell
    }
    
    private func configureSettingsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TrackerCreatorSettingsCell.Identifier,
                            for: indexPath
                ) as? TrackerCreatorSettingsCell else {
                    return UICollectionViewCell()
                }
        
        switch indexPath.item {
        case 0:
            categoryIndexPath = indexPath
            cell.label.text = "Категория"
            let cellType: SettingsMenuCellType = trackerType == .event ? .single : .first
            cell.initCell(cellType)
            cell.addActionOnCellClick {
                self.launchCategorySelector()
            }
        case 1:
            scheduleIndexPath = indexPath
            cell.label.text = "Расписание"
            cell.initCell(.last)
            cell.addActionOnCellClick {
                self.launchScheduler()
            }
        default: break
        }
        return cell
    }
    
    private func configureEmojiCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: EmojiCell.Identifier,
                            for: indexPath
                ) as? EmojiCell else {
                    return UICollectionViewCell()
                }
        cell.setEmoji(
            TrackerEmoji.items[indexPath.item],
            indexPath: indexPath
        )
        cell.setDelegate(self)
        
        return cell
    }

    private func configureColorsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ColorsCell.Identifier,
                            for: indexPath
                ) as? ColorsCell else {
                    return UICollectionViewCell()
                }

        cell.setColor(
            TrackerColors.items[indexPath.item],
            indexPath: indexPath
        )
        cell.setDelegate(self)
        
        return cell
    }

    private func configureButtonsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ButtonsCell.Identifier,
                            for: indexPath
                ) as? ButtonsCell else {
                    return UICollectionViewCell()
                }
        
        cell.setDelegate(self)
        cell.setApplyButton(applyButton)
        cell.initCell()
        
        return cell
    }
    
    private func configureHeader(title: String = "", x: CGFloat = 0, y: CGFloat = 0, collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.Identifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }

        header.label.text = title
        header.configureLablePosition(x: x, y: y)
        return header
    }

}


//MARK: - CollectiionViewCellDelegate
extension TrackerCreatorViewController: TrackerCreatorCVCellDelegate {
    func setSelectedEmojiItem(_ indexPath: IndexPath) {
        currentSelectedEmojiIndexPath = indexPath
        presenter.setEmoji(TrackerEmoji.items[indexPath.item])
    }
    
    func reloadPreviousSelectedEmojiCell() {
        if let currentSelectedEmojiIndexPath {
            eventCreatorCollection.reloadItems(at: [currentSelectedEmojiIndexPath])
        }
    }
    
    func setSelectedColorItem(_ indexPath: IndexPath) {
        currentSelectedColorIndexPath = indexPath
        presenter.setColor(TrackerColors.items[indexPath.item])
    }
    
    func reloadPreviousSelectedColorCell() {
        if let currentSelectedColorIndexPath {
            eventCreatorCollection.reloadItems(at: [currentSelectedColorIndexPath])
        }
    }
    
    func setTrackerTitle(_ title: String) {
        presenter.setTrackerTitle(title)
    }
    
    func onTrackerCreatingCancel() {
        dismiss(animated: true)
    }
}

//MARK: - Configure
extension TrackerCreatorViewController {
    private func configureLayout() {        
        eventCreatorCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        eventCreatorCollection.backgroundColor = .clear
        view.addSubView(
            eventCreatorCollection,
            top: AnchorOf(view.topAnchor),
            bottom: AnchorOf(view.bottomAnchor),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
        eventCreatorCollection.showsVerticalScrollIndicator = false
    }
    
    private func configureCreatorCollectionView() {
        eventCreatorCollection.dataSource = self
        eventCreatorCollection.delegate = self
        
        eventCreatorCollection.register(
            TrackerCreatorTitleCell.self,
            forCellWithReuseIdentifier: TrackerCreatorTitleCell.Identifier
        )
        eventCreatorCollection.register(
            TrackerCreatorSettingsCell.self,
            forCellWithReuseIdentifier: TrackerCreatorSettingsCell.Identifier
        )
        eventCreatorCollection.register(
            EmojiCell.self,
            forCellWithReuseIdentifier: EmojiCell.Identifier
        )
        eventCreatorCollection.register(
            ColorsCell.self,
            forCellWithReuseIdentifier: ColorsCell.Identifier
        )
        eventCreatorCollection.register(
            ButtonsCell.self,
            forCellWithReuseIdentifier: ButtonsCell.Identifier
        )
        
        eventCreatorCollection.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.Identifier
        )
    }
}
