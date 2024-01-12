import Foundation

protocol StatisticRepository {
    
    func savePerfectDay(_ day: Date)
    
    func removePerfectDay(_ day: Date)
    
    func loadPerfectDays() -> Set<Date>
    
}
