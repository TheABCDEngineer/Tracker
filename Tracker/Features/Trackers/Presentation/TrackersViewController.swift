import UIKit

final class TrackersViewController: UIViewController {
    
    var inaccessibleViews = [ViewVisibilityProtocol]()
    
    private let presenter = Creator.injectTrackersPresenter()
    
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
    
    private var checkedTrackerIndexPath: IndexPath?
    
    private let filterDataSource = FilterCVDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureTrackerCollectionView()
        configureFilterCollectionView()
        setObservers()
        presenter.updateData()
    }
    
    @objc
    private func addTrackerButtonClick() {
        eventBottomSheet.show()
    }
    
    @objc
    private func onDatePickerChoose() {
        presenter.setUserDate(datePicker.date)
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
        filterBottomSheet.show()
    }
    
    private func createEvent(event: TrackerType) {
        let controller = TrackerCreatorViewController()
        controller.trackerType = event
        controller.onTrackerCreated { [weak self] in
            guard let self else { return }
            self.presenter.setUserDate(self.datePicker.date)
        }
        self.present(controller, animated: true)
    }
        
    private func setObservers() {
        presenter.ObserveTrackersPacks { [weak self] data in
            guard let self, let data else { return }
            self.trackersFieldData = data
            self.trackersCV.reloadData()
  
            placeholder.view.isHidden = !trackersFieldData.isEmpty
        }
        
        presenter.ObserveModifiedTracker { [weak self] trackerModel in
            guard let self, let trackerModel, let index = checkedTrackerIndexPath else { return }

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
            forCellWithReuseIdentifier: TrackerCell.Identifier
        )
        
        trackersCV.register(
            SectionTitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleHeaderView.Identifier)
        
        trackersCV.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: TitleSupplementaryView.Identifier
        )
    }
    
    private func configureFilterCollectionView() {
        filterCV.dataSource = filterDataSource
        filterDataSource.cellDelegate = self
        
        filterCV.register(
            FilterCell.self,
            forCellWithReuseIdentifier: FilterCell.Identifier
        )
    }
}

//MARK: - TrackersCVCellDelegate
extension TrackersViewController: TrackersCVCellDelegate {
    func onTrackerChecked(for indexPath: IndexPath) {
        checkedTrackerIndexPath = indexPath
        presenter.onTrackerChecked(
            tracker: trackersFieldData[indexPath.section].trackers[indexPath.item]
        )
    }
}

//MARK: - FilterCVCellDelegate
extension TrackersViewController: FilterCellDelegate {
    func onFilterChoose(indexPath: IndexPath, filter: FilterState) {
        filterDataSource.currentFilterState = filter
        presenter.setFilter(filter)
        
        if let previousSelectedCellIndexPath = filterDataSource.selectedCellIndexPath {
            if let cell = filterCV.cellForItem(at: previousSelectedCellIndexPath) as? FilterCell {
                cell.unCheck()
            }
        }
        
        filterDataSource.selectedCellIndexPath = indexPath
        filterBottomSheet.hide()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.Identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        cell.setDelegate(self)
        cell.setIndexPath(indexPath)
        cell.setModel(trackersFieldData[indexPath.section].trackers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.Identifier, for: indexPath) as? TitleSupplementaryView ?? UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleHeaderView.Identifier, for: indexPath) as? SectionTitleHeaderView else { return UICollectionReusableView() }
        
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
            collectionViewLayout: FilterCVFlowLayout.setup(width: filterBottomSheet.view.frame.width-32)
        )

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
