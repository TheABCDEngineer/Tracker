import UIKit

extension TrackersViewController {
    func setupLayout(
        for view: UIView,
        datePicker: UIDatePicker,
        searchingField: UISearchTextField,
        trackersCV: UICollectionView,
        filterCV: UICollectionView,
        eventBottomSheet: BottomSheet,
        filterBottomSheet: BottomSheet,
        placeholder: Placeholder,
        addTrackerButton: UIButton,
        createHabitButton: UIButton,
        createEventButton: UIButton,
        filterButton: UIButton
    ) -> UIView {
        let superView = view
        superView.backgroundColor = .ypWhite
        
        addTrackerButton.tintColor = .ypBlack
        addTrackerButton.backgroundColor = .clear
        superView.addSubView(
            addTrackerButton, width: 42, heigth: 42,
            top: AnchorOf(superView.topAnchor, 44),
            leading: AnchorOf(superView.leadingAnchor, 6)
        )
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
       
        superView.addSubView(
            datePicker, heigth: 34,
            trailing: AnchorOf(superView.trailingAnchor, -16),
            centerY: AnchorOf(addTrackerButton.centerYAnchor)
        )
        
        let trackerLable = UILabel()
        trackerLable.backgroundColor = .clear
        trackerLable.text = "Трекеры"
        trackerLable.textColor = .ypBlack
        trackerLable.font = Font.ypBold34
        superView.addSubView(
            trackerLable,
            top: AnchorOf(addTrackerButton.bottomAnchor, 1),
            leading: AnchorOf(superView.leadingAnchor, 16)
        )
        
        searchingField.placeholder = "Поиск"
        searchingField.textColor = .ypBlack
        searchingField.backgroundColor = .ypSearhingField
        searchingField.font = Font.ypRegular17
        superView.addSubView(
            searchingField, heigth: 36,
            top: AnchorOf(trackerLable.bottomAnchor, 8),
            leading: AnchorOf(trackerLable.leadingAnchor),
            trailing: AnchorOf(superView.trailingAnchor, -16)
        )
        
        trackersCV.backgroundColor = .clear
        superView.addSubView(
            trackersCV,
            top: AnchorOf(searchingField.bottomAnchor, -searchingField.frame.height),
            bottom: AnchorOf(superView.safeAreaLayoutGuide.bottomAnchor),
            leading: AnchorOf(searchingField.leadingAnchor),
            trailing: AnchorOf(searchingField.trailingAnchor)
        )
        trackersCV.showsVerticalScrollIndicator = false
        
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
        
        filterButton.layer.cornerRadius = 16
        filterButton.backgroundColor = .ypBlue
        filterButton.setTitle("Фильтры", for: .normal)
        filterButton.tintColor = .ypWhite
        filterButton.titleLabel?.font = Font.ypRegular17
        
        superView.addSubView(
            filterButton, width: 114, heigth: 50,
            bottom: AnchorOf(superView.bottomAnchor, -98),
            centerX: AnchorOf(superView.centerXAnchor)
        )
        
        filterBottomSheet.backgroundColor = .ypBottomSheet
        filterBottomSheet.cornerRadius = 20
        filterBottomSheet.startHeight = 470
        
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
        
        filterCV.backgroundColor = .clear
        
        filterBottomSheet.view.addSubView(
            filterCV, heigth: 300,
            top: AnchorOf(filterLable.bottomAnchor, 36),
            leading: AnchorOf(filterBottomSheet.view.leadingAnchor, 16),
            trailing: AnchorOf(filterBottomSheet.view.trailingAnchor, -16)
        )
        
        placeholder.image.image = UIImage(named: "TrackerPlaceholder")
        placeholder.label.text = "Что будем отслеживать?"
        superView.addSubView(
            placeholder.view, width: 175, heigth: 125,
            centerX: AnchorOf(superView.centerXAnchor),
            centerY: AnchorOf(superView.centerYAnchor)
        )
        
        return superView
    }
}
