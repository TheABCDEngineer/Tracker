import Foundation

final class TrackersPresenter {
     
    private let dataProcessor: TrackersDataProcessorProtocol
    
    private var currentDate = Date()
    
    private var currentFilter: FilterState = .todayTrackers
    
    private var currentRequiredTrackerSubTitle = ""
    
    private let trackersPacksData = ObservableData<[TrackersPackScreenModel]>()
    
    private let modifiedTracker = ObservableData<TrackerScreenModel>()
    
    init(
        dataProcessor: TrackersDataProcessorProtocol
    ) {
        self.dataProcessor = dataProcessor
    }
    
    func updateData() {
        trackersPacksData.postValue(
            provideScreenData()
        )
    }
    
    func setUserDate(_ date: Date) {
        self.currentDate = date
        updateData()
    }
    
    func setFilter(_ filter: FilterState) {
        self.currentFilter = filter
        updateData()
    }
    
    func setSearchingTrackerTitle(_ sample: String) {
        self.currentRequiredTrackerSubTitle = sample
        updateData()
    }
    
    func onTrackerChecked(tracker: TrackerScreenModel) {
        let updatedCompletedStatus = !tracker.isCompleted

        let updatedCompletedCount = updatedCompletedStatus
            ? dataProcessor.addRecord(for: tracker.id, date: currentDate)
            : dataProcessor.removeRecord(for: tracker.id, date: currentDate)
        
        if currentFilter == .completedTrackers || currentFilter == .uncompletedTrackers {
            updateData()
            return
        }
        
        modifiedTracker.postValue(
            TrackerScreenModel(
                id: tracker.id,
                title: tracker.title,
                emoji: tracker.emoji,
                color: tracker.color,
                daysCount: updatedCompletedCount,
                isCompleted: updatedCompletedStatus,
                isAvailable: tracker.isAvailable
            )
        )
    }
    
    func onRemoveTracker(trackerID: Int) {
        dataProcessor.removeTracker(id: trackerID)
        updateData()
    }
    
//MARK: - Observers
    func ObserveTrackersPacks(_ completion: @escaping ([TrackersPackScreenModel]?) -> Void) {
        trackersPacksData.observe(completion)
    }
    
    func ObserveModifiedTracker(_ completion: @escaping (TrackerScreenModel?) -> Void) {
        modifiedTracker.observe(completion)
    }
    
//MARK: - private funcs
    private func provideScreenData() -> [TrackersPackScreenModel] {
        var resultPackScreenModels = [TrackersPackScreenModel]()
        let trackers = provideTrackersByFilter()

        let trackersPacks = dataProcessor.fetchPacksForTrackers(for: trackers)
        
        for trackersPack in trackersPacks {
            resultPackScreenModels.append(
                providePackScreenModel(
                    for: trackersPack,
                    from: trackers
                )
            )
        }
        return resultPackScreenModels
    }
    
    private func provideTrackersByFilter() -> [TrackerModel] {
        var trackers = [TrackerModel]()
        
        switch currentFilter {
        case .allTrackers:
            trackers = dataProcessor.fetchAllTrackers()
        case .todayTrackers:
            trackers = dataProcessor.fetchTrackersForRequiredDate(where: currentDate)
        case .completedTrackers:
            trackers = dataProcessor.fetchTrackersOnRequiredDateOfCompletedState(
                requiredDate: currentDate,
                isCompleted: true
            )
        case .uncompletedTrackers:
            trackers = dataProcessor.fetchTrackersOnRequiredDateOfCompletedState(
                requiredDate: currentDate,
                isCompleted: false
            )
        }
        
        if currentRequiredTrackerSubTitle.isEmpty { return trackers }
        
        return dataProcessor.fetchTrackersWhereSubTitles(
            from: trackers,
            where: currentRequiredTrackerSubTitle
        )
    }
    
    private func providePackScreenModel(
        for trackersPack: TrackersPack,
        from trackers: [TrackerModel]
    ) -> TrackersPackScreenModel {
        var trackerScreenModels = [TrackerScreenModel]()
        
        if !trackersPack.trackerIDList.isEmpty || !trackers.isEmpty {
            for trackerIDInPack in trackersPack.trackerIDList.sorted() {
                for tracker in trackers {
                    if trackerIDInPack == tracker.id {
                        trackerScreenModels.append(
                            DataConverter.map(
                                tracker: tracker,
                                daysCount: dataProcessor.fetchTrackerCompletionCount(
                                    trackerID: tracker.id
                                ),
                                isCompleted: dataProcessor.fetchTrackerCompletionForDate(
                                    trackerID: tracker.id,
                                    where: currentDate
                                ),
                                isAvailable: !DateFormatterObj.shared.checkFirstDateGreaterThenSecond(
                                    first: currentDate,
                                    second: Date()
                                )
                            )
                        )
                    }
                }
            }
        }
        return TrackersPackScreenModel(
            title: dataProcessor.fetchTitleByCategoryID(trackersPack.categoryID),
            trackers: trackerScreenModels
        )
    }
}
