import UIKit

final class TrackerCreatorViewController: UIViewController {
 
    private var isModifyTracker = false
    
    private let viewModel = Creator.injectTrackerCreatorViewModel()
    
    private var eventCreatorCollection: UICollectionView!
        
    private let applyButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onApplyButtonClick)
    )
    
    private var currentSelectedEmojiIndexPath: IndexPath?
    
    private var currentSelectedColorIndexPath: IndexPath?
    
    private var scheduleIndexPath: IndexPath?
    
    private var categoryIndexPath: IndexPath?
    
    private var titleFieldIndexPath: IndexPath?
    
    private var onTrackerCreated: ( (UUID, UUID, Bool) -> Void )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        setObservers()
        configureCreatorCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isModifyTracker = false
    }
    
    func onTrackerCreated(_ completion: @escaping (UUID, UUID, Bool) -> Void) {
        self.onTrackerCreated = completion
    }
    
    func setTrackerType(_ trackerType: TrackerType?) {
        guard let trackerType else { return }
        viewModel.setTrackerType(trackerType)
    }
    
    func setTrackerIdIfModify(_ id: UUID?) {
        guard let id else { return }
        isModifyTracker = true
        viewModel.setTrackerIdIfModify(id)
    }
    
    private func setObservers() {
        viewModel.observeAllPropertiesDidEnter { [weak self] state in
            guard let self, let state else { return }
            self.updateApplyButtonState(state)
        }
        
        viewModel.observeScheduleCreated { [weak self] scheduleString in
            guard let self, let scheduleString else { return }
            self.updateSublabelInSettingCell(for: scheduleIndexPath, text: scheduleString)
        }
        
        viewModel.observeCategoryCreated { [weak self] categoryTitle in
            guard let self else { return }
            self.updateSublabelInSettingCell(for: categoryIndexPath, text: categoryTitle)
        }
        
        viewModel.observeTrackerIdetified { [weak self] trackerID, categoryID in
            guard let self else { return }
            let didModified = viewModel.modifyingTrackerID != nil
            self.onTrackerCreated?(trackerID, categoryID, didModified)
        }
    }
    
    private func updateApplyButtonState(_ state: ApplyButton.State) {
        applyButton.isUserInteractionEnabled = state.isEnabled
        applyButton.backgroundColor = state.color
    }
        
    private func updateSublabelInSettingCell(for indexPath: IndexPath?, text: String?) {
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
            viewModel.setSchedule(schedule)
        }
        controller.setCurrentSchedule(viewModel.schedule)
        unfocusedTileField()
        self.present(controller, animated: true)
    }
    
    private func launchCategorySelector() {
        let controller = CategorySetterViewController()
        controller.onSetCategory {[weak self] category in
            guard let self else { return }
            viewModel.setCategory(category)
        }
        controller.setInitCategory(viewModel.category)
        unfocusedTileField()
        self.present(controller, animated: true)
    }
    
    @objc
    private func onApplyButtonClick() {
        viewModel.createTracker()
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
            return viewModel.trackerType == .habit ? 2 : 1
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
            return configureHeader(title: localized("emoji"), x: 6, y: 40, collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        case 3:
            return configureHeader(title: localized("color"), x: 6, y: 40, collectionView: collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        default:
            return UICollectionReusableView()
        }
       
    }

    private func configureTitleCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TrackerCreatorTitleCell.identifier,
                            for: indexPath
                ) as? TrackerCreatorTitleCell else {
                    return UICollectionViewCell()
                }
        titleFieldIndexPath = indexPath
        
        var headerTitle = ""
        if isModifyTracker {
            headerTitle = viewModel.trackerType == .habit
                ? localized("edit habbit")
                : localized("edit event")
        } else {
            headerTitle = viewModel.trackerType == .habit
                ? localized("new habbit")
                : localized("new event")
        }
        
        cell.eventLable.text = headerTitle
        cell.setInitTitle(viewModel.title)
        cell.setDelegate(self)
        return cell
    }
    
    private func configureSettingsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TrackerCreatorSettingsCell.identifier,
                            for: indexPath
                ) as? TrackerCreatorSettingsCell else {
                    return UICollectionViewCell()
                }
        
        switch indexPath.item {
        case 0:
            categoryIndexPath = indexPath
            cell.label.text = localized("category")
            let cellType: SettingsMenuCellType = viewModel.trackerType == .event
                ? .single
                : .first
            cell.initCell(cellType)
            
            cell.addActionOnCellClick {
                self.launchCategorySelector()
            }
            if isModifyTracker {
                if let category = viewModel.category {
                    cell.subLabel.text = category.title
                    cell.updateLabels()
                }
            }
        case 1:
            scheduleIndexPath = indexPath
            cell.label.text = localized("schedule")
            cell.initCell(.last)
            
            cell.addActionOnCellClick {
                self.launchScheduler()
            }
            if isModifyTracker {
                cell.subLabel.text = viewModel.convertScheduleToString(viewModel.schedule)
                cell.updateLabels()
            }
        default: break
        }
        return cell
    }
    
    private func configureEmojiCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: EmojiCell.identifier,
                            for: indexPath
                ) as? EmojiCell else {
                    return UICollectionViewCell()
                }
        cell.setEmoji(
            TrackerEmoji.items[indexPath.item],
            indexPath: indexPath
        )
        cell.setDelegate(self)
        
        if isModifyTracker && viewModel.emoji == TrackerEmoji.items[indexPath.item] {
            cell.selectCell()
        }
    
        return cell
    }

    private func configureColorsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ColorsCell.identifier,
                            for: indexPath
                ) as? ColorsCell else {
                    return UICollectionViewCell()
                }

        cell.setColor(
            TrackerColors.items[indexPath.item],
            indexPath: indexPath
        )
        cell.setDelegate(self)
        
        if isModifyTracker {
            if let color = viewModel.color {
                if color.toUIColor() == TrackerColors.items[indexPath.item].toUIColor() {
                    cell.selectCell()
                }
            }
        }
        
        return cell
    }

    private func configureButtonsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ButtonsCell.identifier,
                            for: indexPath
                ) as? ButtonsCell else {
                    return UICollectionViewCell()
                }
        
        cell.setDelegate(self)
        
        let applyButtonTitle = isModifyTracker ? localized("save") : localized("create")
        applyButton.setTitle(applyButtonTitle, for: .normal)
        cell.setApplyButton(applyButton)
        
        cell.initCell()
        
        return cell
    }
    
    private func configureHeader(title: String = "", x: CGFloat = 0, y: CGFloat = 0, collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleHeaderView.identifier, for: indexPath) as? SectionTitleHeaderView else {
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
        viewModel.setEmoji(TrackerEmoji.items[indexPath.item])
    }
    
    func reloadPreviousSelectedEmojiCell() {
        if let currentSelectedEmojiIndexPath {
            eventCreatorCollection.reloadItems(at: [currentSelectedEmojiIndexPath])
        }
    }
    
    func setSelectedColorItem(_ indexPath: IndexPath) {
        currentSelectedColorIndexPath = indexPath
        viewModel.setColor(TrackerColors.items[indexPath.item])
    }
    
    func reloadPreviousSelectedColorCell() {
        if let currentSelectedColorIndexPath {
            eventCreatorCollection.reloadItems(at: [currentSelectedColorIndexPath])
        }
    }
    
    func setTrackerTitle(_ title: String) {
        viewModel.setTrackerTitle(title)
    }
    
    func onTrackerCreatingCancel() {
        dismiss(animated: true)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Configure
extension TrackerCreatorViewController {
    private func configureLayout() {        
        eventCreatorCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        self.view = setupLayout(for: self.view, eventCreatorCollection: eventCreatorCollection)
    }
    
    private func configureCreatorCollectionView() {
        eventCreatorCollection.dataSource = self
        eventCreatorCollection.delegate = self
        
        eventCreatorCollection.register(
            TrackerCreatorTitleCell.self,
            forCellWithReuseIdentifier: TrackerCreatorTitleCell.identifier
        )
        eventCreatorCollection.register(
            TrackerCreatorSettingsCell.self,
            forCellWithReuseIdentifier: TrackerCreatorSettingsCell.identifier
        )
        eventCreatorCollection.register(
            EmojiCell.self,
            forCellWithReuseIdentifier: EmojiCell.identifier
        )
        eventCreatorCollection.register(
            ColorsCell.self,
            forCellWithReuseIdentifier: ColorsCell.identifier
        )
        eventCreatorCollection.register(
            ButtonsCell.self,
            forCellWithReuseIdentifier: ButtonsCell.identifier
        )
        
        eventCreatorCollection.register(
            SectionTitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleHeaderView.identifier
        )
    }
}
