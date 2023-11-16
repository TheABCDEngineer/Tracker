import UIKit

final class TrackersViewController: UIViewController {
    
    var inaccessibleViews = [ViewVisibilityProtocol]()
    
    private let datePicker = UIDatePicker()
    
    private let searchingField = UISearchTextField()
    
    private let trackersField = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var eventBottomSheet: BottomSheet!
    
    private var filterBottomSheet: BottomSheet!
    
    private let placeholder = Placeholder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createEvent(event: .habit)
    }
    
    @objc
    private func addTrackerButtonClick() {
        eventBottomSheet.show()
    }
    
    @objc
    private func onDatePickerChoose() {
        
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
        self.present(controller, animated: true)
    }
    
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
        
        trackersField.backgroundColor = .clear
        view.addSubView(
            trackersField,
            top: AnchorOf(searchingField.bottomAnchor, 8),
            bottom: AnchorOf(view.safeAreaLayoutGuide.bottomAnchor),
            leading: AnchorOf(searchingField.leadingAnchor),
            trailing: AnchorOf(searchingField.trailingAnchor)
        )
        
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
