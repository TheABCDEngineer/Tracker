import Foundation

protocol TrackersDataProcessorProtocol {
    func provideScreenData(
        filterByDate requiredDate: Date
    ) -> [TrackersPackScreenModel]
    
    func setCompletedStatus(
        for tracker: TrackerScreenModel,
        completedDays: Int,
        isCompleted: Bool
    ) -> TrackerScreenModel
}
