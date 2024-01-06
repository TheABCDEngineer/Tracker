import Foundation

final class StatisticRepositoryImplUserDef: StatisticRepository {
   
    private let repository = UserDefaults.standard
    
    private let key = "statistic"
    
    func savePerfectDay(_ day: Date) {
        let dayAlias = DateFormatterObj.shared.convertToInt(day)
        var perfectDaysAlias = loadPerfectDaysAlias()
        perfectDaysAlias.insert(dayAlias)
        
        repository.setJSON(codable: perfectDaysAlias, forKey: key)
    }
    
    func removePerfectDay(_ day: Date) {
        let dayAlias = DateFormatterObj.shared.convertToInt(day)
        var perfectDaysAlias = loadPerfectDaysAlias()
        guard let _ = perfectDaysAlias.remove(dayAlias) else { return }
        
        repository.setJSON(codable: perfectDaysAlias, forKey: key)
    }
    
    func loadPerfectDays() -> Set<Date> {
        let perfectDaysAlias = loadPerfectDaysAlias()
        if perfectDaysAlias.isEmpty { return Set<Date>() }
        
        var perfectDays = Set<Date>()
        for dayAlias in perfectDaysAlias {
            if let day = DateFormatterObj.shared.convertToDate(dayAlias) { perfectDays.insert(day) }
        }
        
        return perfectDays
    }
    
    private func loadPerfectDaysAlias() -> Set<Int> {
        guard let perfectDaysAlias: Set<Int> = repository.getJSON(forKey: key) else { return Set<Int>() }
        return perfectDaysAlias
    }
    
}
