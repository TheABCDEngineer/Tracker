import Foundation

final class StatisticServiceImpl: StatisticServiceProtocol {
    
    private let statisticRepository: StatisticRepository
    
    private let recordsRepository: TrackerRecordsRepository
    
    private var records: [TrackerRecord] { recordsRepository.loadRecords() }
    
    init(
        statisticRepository: StatisticRepository,
        recordsRepository: TrackerRecordsRepository
    ) {
        self.statisticRepository = statisticRepository
        self.recordsRepository = recordsRepository
    }
    
    func getBestPeriod() -> Int {
        var dateAliasList = [Int]()
        for record in records { dateAliasList.append(contentsOf: record.dates) }
 
        var result = 0
        for dateAlias in dateAliasList {
            var repetition = 0
            for _dateAlias in dateAliasList where dateAlias == _dateAlias { repetition += 1 }
            if repetition > result { result = repetition }
        }
        
        return result
    }
    
    func getPerfectDays() -> Int {
        statisticRepository.loadPerfectDays().count
    }
    
    func getTrackersCompleted() -> Int {
        var result = 0
        for record in records { result += record.dates.count }
        return result
    }
    
    func getAverageValue() -> Float {
        var earliestDateAlias = DateFormatterObj.shared.convertToInt(Date())
        
        for record in records {
            for dateAlias in record.dates where dateAlias < earliestDateAlias { earliestDateAlias = dateAlias }
        }
        guard let earliestDate = DateFormatterObj.shared.convertToDate(earliestDateAlias) else { return 0 }
        guard let daysCount = DateFormatterObj.shared.daysBetween(from: earliestDate, to: Date()) else { return 0 }
        let trackerCompletedCount = Float(getTrackersCompleted())
        
        if daysCount == 0 { return trackerCompletedCount }
  
        return trackerCompletedCount/Float(daysCount)
    }
}
