import Foundation

final class TrackersDataProcessorImpl: TrackersDataProcessorProtocol {
    
    private let trackersRepository: TrackersRepository
    
    private let packRepository: CategoryTrackerPackRepository
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let recordsRepository: TrackerRecordsRepository
    
    private var trackers = [TrackerModel]()
    
    private var trackersPacks = [CategoryTrackerPack]()
    
    private var trackerRecords = [TrackerRecord]()
    
    private var trackerScreenModelsForSearching = [TrackerScreenModel]()
    
    init(
        trackersRepository: TrackersRepository,
        categoryRepository: TrackerCategoryRepository,
        packRepository: CategoryTrackerPackRepository,
        recordsRepository: TrackerRecordsRepository
    ) {
        self.trackersRepository = trackersRepository
        self.packRepository = packRepository
        self.categoryRepository = categoryRepository
        self.recordsRepository = recordsRepository
    }
    
    func provideScreenData(
        filterByDate requiredDate: Date
    ) -> [TrackersPackScreenModel] {
        updateAllData()
        var resultPacksModels = [TrackersPackScreenModel]()
        trackerScreenModelsForSearching = provideTrackerScreenModels(for: requiredDate)
        
        for trackersPack in trackersPacks {
            resultPacksModels.append(
                providePackScreenModel(for: trackersPack)
            )
        }
        
        return resultPacksModels
    }
    
    func setCompletedStatus(
        for tracker: TrackerScreenModel,
        completedDays: Int,
        isCompleted: Bool
    ) -> TrackerScreenModel {
        return TrackerScreenModel(
            id: tracker.id,
            title: tracker.title,
            emoji: tracker.emoji,
            color: tracker.color,
            daysCount: completedDays,
            isCompleted: isCompleted,
            isAvailable: tracker.isAvailable
        )
    }
    
    private func provideTrackerScreenModels(for requiredDate: Date) -> [TrackerScreenModel] {
        var trackerScreenModels = [TrackerScreenModel]()
        
        for tracker in trackers where checkTrackerExistForDate(tracker: tracker, for: requiredDate) {
            let record = recordsRepository.getRecordByTrackerID(
                for: tracker.id,
                from: trackerRecords
            )
        
            trackerScreenModels.append(
                DataConverter.map(
                    tracker: tracker,
                    daysCount: record?.dates.count ?? 0,
                    isCompleted: checkRecordContainsDate(for: record, date: requiredDate),
                    isAvailable: !DateFormatterObj.shared.checkFirstDateGreaterThenSecond(first: requiredDate, second: Date())
                )
            )
        }
        return trackerScreenModels
    }
    
    private func providePackScreenModel(
        for trackersPack: CategoryTrackerPack
    ) -> TrackersPackScreenModel {
        let title = categoryRepository.getCategoryById(id: trackersPack.categoryID)?.title ?? ""
        var trackers = [TrackerScreenModel]()
        
        for id in trackersPack.trackerIDList {
            if trackerScreenModelsForSearching.isEmpty { break }
            for index in 0 ... trackerScreenModelsForSearching.count - 1 {
                if trackerScreenModelsForSearching[index].id == id {
                    trackers.append(trackerScreenModelsForSearching[index])
                    trackerScreenModelsForSearching.remove(at: index)
                    break
                }
            }
        }
        return TrackersPackScreenModel(title: title, trackers: trackers)
    }
    
    private func checkTrackerExistForDate(tracker: TrackerModel, for date: Date) -> Bool {
        if tracker.type == .event { return true }
   
        guard let requiredWeekDay = WeekDays(
            rawValue: DateFormatterObj.shared.getWeekDayFromDate(date)
        ) else { return true }
       
        if tracker.schedule.contains(requiredWeekDay) { return true }

        return false
    }
    
    private func checkRecordContainsDate(for record: TrackerRecord?, date: Date) -> Bool {
        guard let record else { return false }
        for recordDate in record.dates {
            if DateFormatterObj.shared.checkPairDatesOnEqual(recordDate, date) {
                return true
            }
        }
        return false
    }
    
    private func updateAllData() {
        trackers = trackersRepository.loadTrackers()
        trackersPacks = packRepository.loadPacks()
        trackerRecords = recordsRepository.loadRecords()
    }
}
