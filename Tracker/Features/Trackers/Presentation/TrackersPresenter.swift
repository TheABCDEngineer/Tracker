import Foundation

final class TrackersPresenter {
     
    private let dataProcessor: TrackersDataProcessorProtocol
    
    private var currentDate = Date()
    
    private var currentFilter: FilterState = .todayTrackers
    
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
        
        printData(trackers)
        
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
        switch currentFilter {
        case .allTrackers:
            return dataProcessor.fetchAllTrackers()
        case .todayTrackers:
            return dataProcessor.fetchTrackersForRequiredDate(where: currentDate)
        case .completedTrackers:
            return dataProcessor.fetchTrackersOnRequiredDateOfCompletedState(
                requiredDate: currentDate,
                isCompleted: true
            )
        case .uncompletedTrackers:
            return dataProcessor.fetchTrackersOnRequiredDateOfCompletedState(
                requiredDate: currentDate,
                isCompleted: false
            )
        }
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
//логирование (будет удалено в финальном комите)
    private func printData(_ trackers: [TrackerModel]) {
        print("FetchingTrackers:")
        print("FilterSettings: data - \(currentDate) filter - \(currentFilter)")
        
        var i = 1
        for tracker in trackers {
            print("---------------------- \(i) --------------------")
            print("ID: \(tracker.id)")
            print("Title: \(tracker.title)")
            print("Type: \(tracker.type)")
            if !tracker.schedule.isEmpty { print("Schedule:") }
            
            for day in tracker.schedule {
                print("-> \(day.description())")
            }
            i += 1
        }
        
        print("----------------------------------------------------")
    }
}
