import UIKit

final class TrackersViewController: UIViewController {
    
    var inaccessibleViews = [ViewVisibilityProtocol]()
    
    private let viewModel = Creator.injectTrackersViewModel()
    
    private let datePicker = UIDatePicker()
    
    private let searchingField = UISearchTextField()
    
    private let trackersCV = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var filterCV: UICollectionView!
    
    private var eventBottomSheet: BottomSheet!
    
    private var filterBottomSheet: BottomSheet!
    
    private let placeholder = Placeholder()
    
    private var trackersFieldData = [TrackersPackScreenModel]()
    
    private var selectedTrackerIndexPath: IndexPath?
    
    private let filterDataSource = FilterCVDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureTrackerCollectionView()
        configureFilterCollectionView()
        setObservers()
        viewModel.updateData()
    }
    
    @objc
    private func addTrackerButtonClick() {
        searchingField.resignFirstResponder()
        eventBottomSheet.show()
    }
    
    @objc
    private func onDatePickerChoose() {
        searchingField.resignFirstResponder()
        viewModel.setUserDate(datePicker.date)
    }
    
    @objc
    private func onCreateHabitButtonClick() {
        eventBottomSheet.hide()
        createEvent(event: .habit)
    }
    
    @objc
    private func onCreateUnregularEventButtonClick() {
        eventBottomSheet.hide()
        createEvent(event: .event)
    }
    
    @objc
    private func onFilterButtonClick() {
        searchingField.resignFirstResponder()
        filterBottomSheet.show()
    }
    
    @objc
    private func onSearchingFieldTextChange() {
        guard let subTitle = searchingField.text else { return }
        viewModel.setSearchingTrackerTitle(subTitle)
    }
    
    private func createEvent(event: TrackerType? = nil, modifyingTrackerID: UUID? = nil) {
        let controller = TrackerCreatorViewController()
        controller.setTrackerType(event)
        controller.setTrackerIdIfModify(modifyingTrackerID)
        controller.onTrackerCreated { [weak self] in
            guard let self else { return }
            self.viewModel.updateData()
        }
        self.present(controller, animated: true)
    }
        
    private func setObservers() {
        viewModel.ObserveTrackersPacks { [weak self] data in
            guard let self, let data else { return }
            self.trackersFieldData = data
            self.trackersCV.reloadData()
  
            placeholder.view.isHidden = !trackersFieldData.isEmpty
        }
        
        viewModel.ObserveModifiedTracker { [weak self] trackerModel in
            guard let self, let trackerModel, let index = selectedTrackerIndexPath else { return }

            self.trackersFieldData[index.section].trackers[index.item] = trackerModel
 
            let cell = trackersCV.cellForItem(at: index) as? TrackerCell ?? TrackerCell()
            cell.setModel(trackerModel)
  
        }
    }
    
    private func configureTrackerCollectionView() {
        trackersCV.dataSource = self
        trackersCV.delegate = self
        
        trackersCV.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        
        trackersCV.register(
            SectionTitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleHeaderView.identifier)
        
        trackersCV.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: TitleSupplementaryView.identifier
        )
    }
    
    private func configureFilterCollectionView() {
        filterCV.dataSource = filterDataSource
        filterDataSource.cellDelegate = self
        
        filterCV.register(
            FilterCell.self,
            forCellWithReuseIdentifier: FilterCell.identifier
        )
    }
}

//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - AlertPresenterProtocol
extension TrackersViewController: AlertPresenterProtocol {
    func present(alert: UIAlertController, animated: Bool) {
        self.present(alert, animated: animated)
    }
}

//MARK: - TrackersCVCellDelegate
extension TrackersViewController: TrackersCVCellDelegate {
    func onTrackerChecked(for indexPath: IndexPath) {
        selectedTrackerIndexPath = indexPath
        viewModel.onTrackerChecked(
            tracker: trackersFieldData[indexPath.section].trackers[indexPath.item]
        )
    }
}

//MARK: - FilterCVCellDelegate
extension TrackersViewController: FilterCellDelegate {
    func onFilterChoose(indexPath: IndexPath, filter: FilterState) {
        filterDataSource.currentFilterState = filter
        viewModel.setFilter(filter)
        
        if let previousSelectedCellIndexPath = filterDataSource.selectedCellIndexPath {
            if let cell = filterCV.cellForItem(at: previousSelectedCellIndexPath) as? FilterCell {
                cell.unCheck()
            }
        }
        
        filterDataSource.selectedCellIndexPath = indexPath
        filterBottomSheet.hide()
    }
}

//MARK: - UIContextMenuInteractionDelegate
extension TrackersViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {        
        return ContextMenuConfigurator.setupMenu(
            alertPresenter: self,
            editAction: { [weak self] in
                guard let self else { return }
                guard let indexPath = self.selectedTrackerIndexPath else { return }
                let trackerId = self.trackersFieldData[indexPath.section].trackers[indexPath.item].id
                self.createEvent(modifyingTrackerID: trackerId)
            },
            removeMessage: "Уверены что хотите удалить трекер?",
            removeAction: { [weak self] in
                guard let self else { return }
                guard let indexPath = self.selectedTrackerIndexPath else { return }
                let trackerId = self.trackersFieldData[indexPath.section].trackers[indexPath.item].id
                self.viewModel.onRemoveTracker(trackerID: trackerId)
            }
        )
    }
}

//MARK: - TrackersCollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        searchingField.resignFirstResponder()
        selectedTrackerIndexPath = indexPath
        return true
    }
}

//MARK: - TrackersCollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackersFieldData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackersFieldData[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        cell.setDelegates(cellDelegate: self, contextMenuDelegate: self)
        cell.setIndexPath(indexPath)
        cell.setModel(trackersFieldData[indexPath.section].trackers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.identifier, for: indexPath) as? TitleSupplementaryView ?? UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleHeaderView.identifier, for: indexPath) as? SectionTitleHeaderView else { return UICollectionReusableView() }
        
        header.configureLablePosition(x: 12, y: 16)
        header.label.text = trackersFieldData[indexPath.section].title
        
        return header
    }
}

//MARK: - configure layout
extension TrackersViewController {
    private func configureLayout() {
        let addTrackerButton = UIButton.systemButton(
            with: UIImage(named: "Add Tracker") ?? UIImage(),
            target: nil,
            action: #selector(addTrackerButtonClick)
        )

        datePicker.addTarget(self, action: #selector(onDatePickerChoose), for: .valueChanged)

        eventBottomSheet = BottomSheet(
            with: view,
            viewsAboveSuperView: inaccessibleViews
        )
        
        let createHabitButton = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(onCreateHabitButtonClick)
        )
        
        let createEventButton = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(onCreateUnregularEventButtonClick)
        )
        
        let filterButton = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(onFilterButtonClick)
        )
        
        filterBottomSheet = BottomSheet(
            with: view,
            viewsAboveSuperView: inaccessibleViews
        )
        
        filterCV = UICollectionView(
            frame: .zero,
            collectionViewLayout: FilterCVFlowLayout.setup(
                width: filterBottomSheet.view.frame.width - 32)
        )
        
        searchingField.addTarget(nil,
            action: #selector(onSearchingFieldTextChange), for: .allEditingEvents)
        
        searchingField.delegate = self

        self.view = setupLayout(
            for: self.view,
            datePicker: datePicker,
            searchingField: searchingField,
            trackersCV: trackersCV,
            filterCV: filterCV,
            eventBottomSheet: eventBottomSheet,
            filterBottomSheet: filterBottomSheet,
            placeholder: placeholder,
            addTrackerButton: addTrackerButton,
            createHabitButton: createHabitButton,
            createEventButton: createEventButton,
            filterButton: filterButton
        )
    }
}
