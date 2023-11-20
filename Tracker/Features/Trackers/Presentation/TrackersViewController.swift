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
    
    private var eventBottomSheet: BottomSheet!
    
    private var filterBottomSheet: BottomSheet!
    
    private let placeholder = Placeholder()
    
    private var trackersFieldData = [TrackersPackScreenModel]()
    
    private var checkedTrackerIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        configureLayout()
        configureTrackerCollectionView()
        setObservers()
        presenter.onViewLoaded()
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
    
    @objc
    private func applyFilter() {
        
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

//MARK: - CollectionViewDataSource
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
        addTrackerButton.tintColor = .ypBlack
        addTrackerButton.backgroundColor = .clear
        view.addSubView(
            addTrackerButton, width: 42, heigth: 42,
            top: AnchorOf(view.topAnchor, 44),
            leading: AnchorOf(view.leadingAnchor, 6)
        )
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(onDatePickerChoose), for: .valueChanged)
        view.addSubView(
            datePicker, heigth: 34,
            trailing: AnchorOf(view.trailingAnchor, -16),
            centerY: AnchorOf(addTrackerButton.centerYAnchor)
        )
        
        let trackerLable = UILabel()
        trackerLable.backgroundColor = .clear
        trackerLable.text = "Трекеры"
        trackerLable.textColor = .ypBlack
        trackerLable.font = Font.ypBold34
        view.addSubView(
            trackerLable,
            top: AnchorOf(addTrackerButton.bottomAnchor, 1),
            leading: AnchorOf(view.leadingAnchor, 16)
        )
        
        searchingField.placeholder = "Поиск"
        searchingField.textColor = .ypBlack
        searchingField.backgroundColor = .ypSearhingField
        searchingField.font = Font.ypRegular17
        view.addSubView(
            searchingField, heigth: 36,
            top: AnchorOf(trackerLable.bottomAnchor, 8),
            leading: AnchorOf(trackerLable.leadingAnchor),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
        
        trackersCV.backgroundColor = .clear
        view.addSubView(
            trackersCV,
            top: AnchorOf(searchingField.bottomAnchor, -searchingField.frame.height),
            bottom: AnchorOf(view.safeAreaLayoutGuide.bottomAnchor),
            leading: AnchorOf(searchingField.leadingAnchor),
            trailing: AnchorOf(searchingField.trailingAnchor)
        )
        trackersCV.showsVerticalScrollIndicator = false
        
        eventBottomSheet = BottomSheet(
            with: view,
            viewsAboveSuperView: inaccessibleViews
        )
        eventBottomSheet.backgroundColor = .ypBottomSheet
        eventBottomSheet.cornerRadius = 20
        eventBottomSheet.startHeight = 300
        
        let createTrackerLable = UILabel()
        createTrackerLable.backgroundColor = .clear
        createTrackerLable.text = "Создание трекера"
        createTrackerLable.textColor = .ypBlack
        createTrackerLable.font = Font.ypMedium16
        
        eventBottomSheet.view.addSubView(
            createTrackerLable,
            top: AnchorOf(eventBottomSheet.view.topAnchor, 28),
            centerX: AnchorOf(eventBottomSheet.view.centerXAnchor)
        )
        
        let createHabitButton = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(onCreateHabitButtonClick)
        )
        createHabitButton.layer.cornerRadius = 16
        createHabitButton.backgroundColor = .ypBlack
        createHabitButton.setTitle("Привычка", for: .normal)
        createHabitButton.tintColor = .ypWhite
        createHabitButton.titleLabel?.font = Font.ypMedium16
        
        eventBottomSheet.view.addSubView(
            createHabitButton, heigth: 60,
            top: AnchorOf(createTrackerLable.bottomAnchor, 28),
            leading: AnchorOf(eventBottomSheet.view.leadingAnchor, 20),
            trailing: AnchorOf(eventBottomSheet.view.trailingAnchor, -20)
        )
        
        let createEventButton = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(onCreateUnregularEventButtonClick)
        )
        createEventButton.layer.cornerRadius = 16
        createEventButton.backgroundColor = .ypBlack
        createEventButton.setTitle("Нерегулярное событие", for: .normal)
        createEventButton.tintColor = .ypWhite
        createEventButton.titleLabel?.font = Font.ypMedium16
        
        eventBottomSheet.view.addSubView(
            createEventButton, heigth: 60,
            top: AnchorOf(createHabitButton.bottomAnchor, 16),
            leading: AnchorOf(eventBottomSheet.view.leadingAnchor, 20),
            trailing: AnchorOf(eventBottomSheet.view.trailingAnchor, -20)
        )
        
        let filterButton = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(onFilterButtonClick)
        )
        filterButton.layer.cornerRadius = 16
        filterButton.backgroundColor = .ypBlue
        filterButton.setTitle("Фильтры", for: .normal)
        filterButton.tintColor = .ypWhite
        filterButton.titleLabel?.font = Font.ypRegular17
        
        view.addSubView(
            filterButton, width: 114, heigth: 50,
            bottom: AnchorOf(view.bottomAnchor, -98),
            centerX: AnchorOf(view.centerXAnchor)
        )
        
        filterBottomSheet = BottomSheet(
            with: view,
            viewsAboveSuperView: inaccessibleViews
        )
        filterBottomSheet.backgroundColor = .ypBottomSheet
        filterBottomSheet.cornerRadius = 20
        filterBottomSheet.startHeight = 450
        
        let filterLable = UILabel()
        filterLable.backgroundColor = .clear
        filterLable.text = "Фильтры"
        filterLable.textColor = .ypBlack
        filterLable.font = Font.ypMedium16
        
        filterBottomSheet.view.addSubView(
            filterLable,
            top: AnchorOf(filterBottomSheet.view.topAnchor, 28),
            centerX: AnchorOf(filterBottomSheet.view.centerXAnchor)
        )
        
        placeholder.image.image = UIImage(named: "TrackerPlaceholder")
        placeholder.label.text = "Что будем отслеживать?"
        view.addSubView(
            placeholder.view, width: 175, heigth: 125,
            centerX: AnchorOf(view.centerXAnchor),
            centerY: AnchorOf(view.centerYAnchor)
        )
    }
}
