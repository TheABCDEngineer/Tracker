import Foundation

final class SchedulerPresenter {
    
    private (set) var schedule = Set<WeekDays>()
    
    private (set) var initSchedule = Dictionary<Int, WeekDays>()
    
    private let scheduleState = ObservableData<ApplyButton.State>()
    
    func setSchedule(_ schedule: Set<WeekDays>) {
        if schedule.isEmpty {
            initSchedule = Dictionary()
            return
        }
        
        self.schedule = schedule
        
        initSchedule = WeekDays.sort(schedule)
 
        scheduleState.postValue(ApplyButton.active)
    }
    
    func setSelectedDay(_ day: WeekDays) {
        schedule.insert(day)
        scheduleState.postValue(ApplyButton.active)
    }
    
    func removeUnselectedDay(_ day: WeekDays) {
        schedule.remove(day)
        if !schedule.isEmpty { return }
        scheduleState.postValue(ApplyButton.inactive)
    }
    
    func observeScheduleState(_ completion: @escaping (ApplyButton.State?) -> Void) {
        scheduleState.observe(completion)
    }
}
