import Foundation

final class TrackerCreatorViewModel {
    
    private let trackersRepository: TrackersRepository
    
    private let packRepository: TrackersPackRepository
    
    private let categoryRepository: TrackerCategoryRepository
    
    private (set) var modifyingTrackerID: UUID?
    
    private (set) var trackerType: TrackerType = .event
    
    private (set) var title: String = ""
    
    private (set) var category: TrackerCategory?
    
    private (set) var schedule = Set<WeekDays>()
    
    private (set) var emoji: String = ""
    
    private (set) var color: TrackerColor?
    
    private var takenTrackerTitles = Set<String>()
    
    private let allPropertiesDidEnter = ObservableData<ApplyButton.State>()
    
    private let categoryCreated = ObservableData<String>()
    
    private let scheduleCreated = ObservableData<String>()
    
    private var identifyTracker: ( (UUID, UUID) -> Void )?
    
    init(
        trackersRepository: TrackersRepository,
        packRepository: TrackersPackRepository,
        categoryRepository: TrackerCategoryRepository
    ) {
        self.trackersRepository = trackersRepository
        self.packRepository = packRepository
        self.categoryRepository = categoryRepository
        
        let trackers = trackersRepository.loadTrackers()
        for tracker in trackers {
            self.takenTrackerTitles.insert(tracker.title)
        }
    }
    
    func setTrackerIdIfModify(_ id: UUID) {
        guard
            let tracker = trackersRepository.getTrackerByID(id),
            let pack = packRepository.getPackByTrackerID(id),
            let category = categoryRepository.getCategoryById(id: pack.categoryID)
        else { return }
        
        modifyingTrackerID = id
        self.trackerType = tracker.type
        self.title = tracker.title
        self.category = category
        self.schedule = tracker.schedule
        self.emoji = tracker.emoji
        self.color = tracker.color
        
        takenTrackerTitles.remove(title)
    }
    
    func setTrackerType(_ type: TrackerType) {
        trackerType = type
    }
    
    func setTrackerTitle(_ title: String) {
        self.title = title
        updateAllPropertiesDidEnterState()
    }
    
    func setCategory(_ category: TrackerCategory?) {
        self.category = category
        updateAllPropertiesDidEnterState()
        categoryCreated.postValue(category?.title)
    }
    
    func setSchedule(_ schedule: Set<WeekDays>) {
        if schedule.isEmpty { return }
        self.schedule = schedule
        updateAllPropertiesDidEnterState()
        scheduleCreated.postValue(
            convertScheduleToString(schedule)
        )
    }
    
    func setEmoji(_ emoji: String) {
        self.emoji = emoji
        updateAllPropertiesDidEnterState()
    }
    
    func setColor(_ color: TrackerColor) {
        self.color = color
        updateAllPropertiesDidEnterState()
    }
    
    func createTracker() {
        guard let category else { return }
        
        if let modifyingTrackerID {
            updateTracker(trackerID: modifyingTrackerID)
            identifyTracker?(modifyingTrackerID, category.id)
            return
        }
        
        guard let color else { return }
        guard let tracker = trackersRepository.createTracker(
            type: trackerType,
            title: title,
            schedule: schedule,
            emoji: emoji,
            color: color
        ) else { return }
        
        packRepository.addTrackerToCategory(
            trackerID: tracker.id, categoryID: category.id
        )
        identifyTracker?(tracker.id, category.id)
    }
    
    func convertScheduleToString(_ schedule: Set<WeekDays>) -> String {
        if schedule.isEmpty { return "" }
        
        if schedule.count == 2
            && schedule.contains(.saturday)
            && schedule.contains(.sunday)
        {
            return localized("hollidays")
        }
        
        if schedule.count == 5
            && !schedule.contains(.saturday)
            && !schedule.contains(.sunday)
        {
            return localized("weekdays")
        }
        
        let sortedSchedule = WeekDays.sort(schedule)
        var result = ""
        
        for i in 0 ... WeekDays.allCases.count-1 {
            if let day = sortedSchedule[i] {
                result += "\(day.shortDescription()), "
            }
        }
        return String(result.dropLast(2))
    }
    
//MARK: - Observers
    func observeAllPropertiesDidEnter(_ completion: @escaping (ApplyButton.State?) -> Void) {
        allPropertiesDidEnter.observe(completion)
    }
    
    func observeCategoryCreated(_ completion: @escaping (String?) -> Void) {
        categoryCreated.observe(completion)
    }
    
    func observeScheduleCreated(_ completion: @escaping (String?) -> Void) {
        scheduleCreated.observe(completion)
    }
    
    func observeTrackerIdetified(_ completion: @escaping (UUID, UUID) -> Void) {
        identifyTracker = completion
    }
    
//MARK: - Private
    private func updateAllPropertiesDidEnterState() {
        var isEnter = true
        if title.isEmpty || takenTrackerTitles.contains(title) { isEnter = false }
        if category == nil { isEnter = false }
        if schedule.isEmpty && trackerType == .habit { isEnter = false }
        if emoji.isEmpty { isEnter = false }
        if color == nil { isEnter = false }

        if isEnter {
            allPropertiesDidEnter.postValue(ApplyButton.active)
        } else {
            allPropertiesDidEnter.postValue(ApplyButton.inactive)
        }
    }
    
    private func updateTracker(trackerID: UUID) {
        guard let category else { return }
        guard let tracker = trackersRepository.updateTracker(
            for: trackerID,
            type: trackerType,
            title: title,
            schedule: schedule,
            emoji: emoji,
            color: color
        ) else { return }
        
        guard let pack =
                packRepository.getPackByTrackerID(trackerID) else { return }
        
        if pack.categoryID == category.id { return }
        
        packRepository.removeTrackerFromCategory(trackerID: trackerID)
        
        packRepository.addTrackerToCategory(
            trackerID: tracker.id, categoryID: category.id
        )
    }
}
