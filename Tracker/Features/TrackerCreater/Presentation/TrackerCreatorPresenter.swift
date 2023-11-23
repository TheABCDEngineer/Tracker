import Foundation

final class TrackerCreatorPresenter {
    
    private let trackersRepository: TrackersRepository
    
    private let packRepository: TrackersPackRepository
    
    private var trackerType: TrackerType = .event
    
    private var title: String = ""
    
    private (set) var category: TrackerCategory?
    
    private (set) var schedule = Set<WeekDays>()
    
    private var emoji: String = ""
    
    private var color: TrackerColor?
    
    private var takenTrackerTitles = Set<String>()
    
    private let allPropertiesDidEnter = ObservableData<ApplyButton.State>()
    
    private let categoryCreated = ObservableData<String>()
    
    private let scheduleCreated = ObservableData<String>()
    
    init(
        trackersRepository: TrackersRepository,
        packRepository: TrackersPackRepository
    ) {
        self.trackersRepository = trackersRepository
        self.packRepository = packRepository
        
        let trackers = trackersRepository.loadTrackers()
        for tracker in trackers {
            self.takenTrackerTitles.insert(tracker.title)
        }
    }
    
    func setTrackerType(_ type: TrackerType) {
        trackerType = type
    }
    
    func setTrackerTitle(_ title: String) {
        self.title = title
        updateAllPropertiesDidEnterState()
    }
    
    func setCategory(_ category: TrackerCategory) {
        self.category = category
        updateAllPropertiesDidEnterState()
        categoryCreated.postValue(category.title)
    }
    
    func setSchedule(_ schedule: Set<WeekDays>) {
        if schedule.isEmpty { return }
        self.schedule = schedule
        updateAllPropertiesDidEnterState()
        scheduleCreated.postValue(
            convertSheduleToString(schedule)
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
        guard let category, let color else { return }
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
    
    private func convertSheduleToString(_ schedule: Set<WeekDays>) -> String {
        if schedule.isEmpty { return "" }
        
        if schedule.count == 2
            && schedule.contains(.saturday)
            && schedule.contains(.sunday)
        {
            return "Выходные дни"
        }
        
        if schedule.count == 5
            && !schedule.contains(.saturday)
            && !schedule.contains(.sunday)
        {
            return "Будние дни"
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
}
