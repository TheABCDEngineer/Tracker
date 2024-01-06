import Foundation

final class StatisticViewModel {
    
    private let statisticService: StatisticServiceProtocol
    
    private var statisticData = [StatisticScreenModel]()
    
    private var updatePlaceholderState: ( (Bool) -> Void )?
    
    private var updateStatisticData: ( () -> Void )?
    
    init(
        statisticService: StatisticServiceProtocol
    ) {
        self.statisticService = statisticService
        self.statisticData = updateData()
    }

    func onViewLoaded() {
        let placeholderIsHidden = statisticService.getTrackersCompleted() > 0
        updatePlaceholderState?(placeholderIsHidden)
        
        if !placeholderIsHidden { return }
        
        statisticData = updateData()
        updateStatisticData?()
    }
    
    func observePlaceholderState(_ comletion: @escaping (Bool) -> Void) {
        updatePlaceholderState = comletion
    }
    
    func observeStatisticUpdated(_ completion: @escaping () -> Void) {
        updateStatisticData = completion
    }
    
//MARK: - ScreenDataSource aka Fetch Result Controller
    func itemsCount() -> Int {
        statisticData.count
    }
    
    func object(for indexPath: IndexPath) -> StatisticScreenModel {
        statisticData[indexPath.item]
    }

//MARK: - Private funcs
    private func updateData() -> [StatisticScreenModel] {
        [
            StatisticScreenModel(
                description: localized("best period"),
                value: String(statisticService.getBestPeriod())
            ),
            StatisticScreenModel(
                description: localized("perfect days"),
                value: String(statisticService.getPerfectDays())
            ),
            StatisticScreenModel(
                description: localized("trackers completed"),
                value: String(statisticService.getTrackersCompleted())
            ),
            StatisticScreenModel(
                description: localized("average value"),
                value: String(format: "%.1f",statisticService.getAverageValue())
            )
        ]
    }
}
