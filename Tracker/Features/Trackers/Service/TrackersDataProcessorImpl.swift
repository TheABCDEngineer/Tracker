import Foundation

final class TrackersDataProcessorImpl: TrackersDataProcessorProtocol {
    
    private let trackersRepository: TrackersRepository
    
    private let packRepository: TrackersPackRepository
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let recordsRepository: TrackerRecordsRepository
    
    init(
        trackersRepository: TrackersRepository,
        categoryRepository: TrackerCategoryRepository,
        packRepository: TrackersPackRepository,
        recordsRepository: TrackerRecordsRepository
    ) {
        self.trackersRepository = trackersRepository
        self.packRepository = packRepository
        self.categoryRepository = categoryRepository
        self.recordsRepository = recordsRepository
        
        printData()
    }
  
    func fetchAllTrackers() -> [TrackerModel] {
        return trackersRepository.loadTrackers()
    }
    
    func fetchTrackersOnRequiredDateOfCompletedState(
        requiredDate: Date,
        isCompleted: Bool
    ) -> [TrackerModel] {
        let allTrackersOnRequiredDate = fetchTrackersForRequiredDate(where: requiredDate)
        var requiredTrackers = [TrackerModel]()
        if allTrackersOnRequiredDate.isEmpty { return requiredTrackers }
        
        for tracker in allTrackersOnRequiredDate where fetchTrackerCompletionForDate(
            trackerID: tracker.id,
            where: requiredDate
        ) == isCompleted {
            requiredTrackers.append(tracker)
        }
        
        return requiredTrackers
    }
  
    func fetchTrackersForRequiredDate(where requiredDate: Date) -> [TrackerModel] {
        var requiredTrackers = [TrackerModel]()
        let trackers = trackersRepository.loadTrackers()
        
        for tracker in trackers where checkTrackerExistForDate(tracker: tracker, for: requiredDate) {
            requiredTrackers.append(tracker)
        }
        return requiredTrackers
    }
    
    func fetchTrackerCompletionForDate(trackerID: Int, where requiredDate: Date) -> Bool {
        guard let record = recordsRepository.getRecordByTrackerID(for: trackerID)
            else { return false }
        let tracker = trackersRepository.getTrackerByID(trackerID)
        
        for recordDate in record.dates {
            if DateFormatterObj.shared.checkPairDatesOnEqual(recordDate, requiredDate) {
                return true
            }
        }
        return false
    }
    
    func fetchTrackerCompletionCount(trackerID: Int) -> Int {
        let record = recordsRepository.getRecordByTrackerID(for: trackerID)
        return record?.dates.count ?? 0
    }
    
    func fetchPacksForTrackers(for requiredTrackers: [TrackerModel]) -> [TrackersPack] {
        var categories = Set<Int>()

        for tracker in requiredTrackers {
            if let pack = packRepository.getPackByTrackerID(tracker.id) {
                categories.insert(pack.categoryID)
            }
        }

        return categories.sorted().map {
            packRepository.getPackByCategoryID($0)
        }
    }
    
    func fetchTitleByCategoryID(_ id: Int) -> String {
        return categoryRepository.getCategoryById(id: id)?.title ?? "Без названия"
    }
    
    func fetchTrackerByID(_ id: Int) -> TrackerModel? {
        return trackersRepository.getTrackerByID(id)
    }
    
    func addRecord(for trackerID: Int, date: Date) -> Int {
        let record = recordsRepository.saveRecord(for: trackerID, date: date)
        return record.dates.count
    }
    
    func removeRecord(for trackerID: Int, date: Date) -> Int {
        recordsRepository.removeRecord(for: trackerID, date: date)
        let record = recordsRepository.getRecordByTrackerID(for: trackerID)
        return record?.dates.count ?? 0
    }
    
    func removeTracker(id: Int) {
        recordsRepository.removeRecords(for: id)
        packRepository.removeTrackerFromCategory(trackerID: id)
        trackersRepository.removeTracker(id: id)
    }
 
 //MARK: - Private funcs
    private func checkTrackerExistForDate(tracker: TrackerModel, for date: Date) -> Bool {
        if tracker.type == .event { return true }
   
        guard let requiredWeekDay = WeekDays(
            rawValue: DateFormatterObj.shared.getWeekDayFromDate(date)
        ) else { return true }
       
        if tracker.schedule.contains(requiredWeekDay) { return true }

        return false
    }

//логирование (будет удалено в финальном комите)
    private func printData() {
        print("Trackers:")
        
        var i = 1
        for tracker in trackersRepository.loadTrackers() {
            print("---------------------- \(i) --------------------")
            print("ID: \(tracker.id)")
            print("Title: \(tracker.title)")
            print("Type: \(tracker.type)")
            if !tracker.schedule.isEmpty { print("Schedule:") }
            
            for day in tracker.schedule {
                print("-> \(day.description())")
            }
            
            for pack in packRepository.loadPacks() {
                for id in pack.trackerIDList {
                    if tracker.id == id {
                        let title = categoryRepository.getCategoryById(
                            id: pack.categoryID
                        )?.title
                        print("Pack: \(title!)")
                    }
                }
            }
            
           i += 1
        }
        print("___________________________________________")
    }
}
