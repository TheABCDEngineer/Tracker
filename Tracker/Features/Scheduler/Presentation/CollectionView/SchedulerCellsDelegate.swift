import Foundation

protocol SchedulerCellsDelegate {
    func setSelectedDay(_ day: WeekDays)
    
    func removeUnselectedDay(_ day: WeekDays)
    
    func setSchedule()
}
