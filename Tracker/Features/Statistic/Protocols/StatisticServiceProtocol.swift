import Foundation

protocol StatisticServiceProtocol {
    
    func getBestPeriod() -> Int
    
    func getPerfectDays() -> Int
    
    func getTrackersCompleted() -> Int
    
    func getAverageValue() -> Float
    
}
