import UIKit

final class SchedulerViewController: UIViewController {
    
    private var schedulerCollection: UICollectionView!
    
    private let applyButton = UIButton.systemButton(
        with: UIImage(), target: nil, action: #selector(onApplyButtonClick)
    )
    
    private var onSetSchedule: ( (Set<WeekDays>) -> Void )?
    
    private let viewModel = Creator.injectSchedulerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaout()
        configureSchedulerCollectionView()
        if viewModel.initSchedule.isEmpty {
            configureObservers()
            applyButton.backgroundColor = ApplyButton.inactive.color
            applyButton.isUserInteractionEnabled = ApplyButton.inactive.isEnabled
        }
    }
    
    func onSetSchedule(_ copmletion: @escaping (Set<WeekDays>) -> Void) {
        onSetSchedule = copmletion
    }
    
    func setCurrentSchedule(_ schedule: Set<WeekDays>) {
        configureObservers()
        viewModel.setSchedule(schedule)
    }

    private func configureLaout() {
        schedulerCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        self.view = setupLayout(
            for: self.view,
            schedulerCollection: schedulerCollection,
            applyButton: applyButton
        )
    }
    
    private func configureSchedulerCollectionView() {
        schedulerCollection.dataSource = self
        schedulerCollection.delegate = self
        
        schedulerCollection.register(
            SchedulerCell.self,
            forCellWithReuseIdentifier: SchedulerCell.identifier
        )
        schedulerCollection.register(
            SchedulerButtonsCell.self,
            forCellWithReuseIdentifier: SchedulerButtonsCell.identifier
        )
        schedulerCollection.register(
            TitleSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleSupplementaryView.identifier
        )
    }
    
    private func configureObservers() {
        viewModel.observeScheduleState { [weak self] state in
            guard let self, let state else { return }
            self.updateApplyButtonState(state)
        }
    }
    
    private func updateApplyButtonState(_ state: ApplyButton.State) {
        applyButton.isUserInteractionEnabled = state.isEnabled
        applyButton.backgroundColor = state.color
    }
    
    @objc
    private func onApplyButtonClick() {
        onSetSchedule?(viewModel.schedule)
        dismiss(animated: true)
    }
}

//MARK: - CellDelegate
extension SchedulerViewController: SchedulerCellsDelegate {
    func setSelectedDay(_ day: WeekDays) {
        viewModel.setSelectedDay(day)
    }
    
    func removeUnselectedDay(_ day: WeekDays) {
        viewModel.removeUnselectedDay(day)
    }
    
    func setSchedule() {
        onSetSchedule?(viewModel.schedule)
        dismiss(animated: true)
    }
}

//MARK: - SchedulerCollectionViewDataSource
extension SchedulerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return WeekDays.allCases.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item < WeekDays.allCases.count {
            return configureScheduleCell(for: collectionView, with: indexPath)
        }
        return configureButtonsCell(for: collectionView, with: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSupplementaryView.identifier, for: indexPath) as? TitleSupplementaryView else {
            return UICollectionReusableView()
        }
        header.label.text = localized("schedule")
     
        return header
    }
    
    private func configureScheduleCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: SchedulerCell.identifier,
                            for: indexPath
                ) as? SchedulerCell else {
                    return UICollectionViewCell()
                }
       
        cell.setDelegate(self)
        cell.day = WeekDays(rawValue: indexPath.item)
        cell.isActive = viewModel.initSchedule[indexPath.item] != nil ? true : false
        
        switch indexPath.item {
        case 0:
            cell.initCell(.first)
        case WeekDays.allCases.count - 1:
            cell.initCell(.last)
        default:
            cell.initCell(.regular)
        }
        
        return cell
    }
    
    private func configureButtonsCell(for collectionView: UICollectionView, with indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let
                cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SchedulerButtonsCell.identifier,
                    for: indexPath
                ) as? SchedulerButtonsCell else {
                    return UICollectionViewCell()
                }
        cell.setApplyButton(applyButton)
        cell.initCell()
        return cell
    }
}
