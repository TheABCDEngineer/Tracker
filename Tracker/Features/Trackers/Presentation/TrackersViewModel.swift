import Foundation

struct UpdateOptions {
    let isReload: Bool
    let updatedIndexPath: IndexPath?
    let insertedIndexPaths: [IndexPath]
    let deletedIndexPaths: [IndexPath]
    
    init(isReload: Bool = false, updatedIndexPath: IndexPath? = nil, insertedIndexPaths: [IndexPath] = [IndexPath](), deletedIndexPaths: [IndexPath] = [IndexPath]()
    ) {
        self.isReload = isReload
        self.updatedIndexPath = updatedIndexPath
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
    }
}

final class TrackersViewModel {
     
    private let dataProcessor: TrackersDataProcessorProtocol
    
    private var userDate = Date()
    
    private var currentFilter: FilterState = .todayTrackers
    
    private var currentRequiredTrackerSubTitle = ""
    
    private var presentedTrackerPacks = [TrackersPackData]()
   
    private var updateTrackers: ( (UpdateOptions) -> Void )?
    
    private var placeholderState = ObservableData<TrackersPlaceholder.State>()
    
    init(dataProcessor: TrackersDataProcessorProtocol) {
        self.dataProcessor = dataProcessor
    }
    
    func onViewLoaded() {
        setPlaceholderState()
        updateData()
    }
    
    func setUserDate(_ date: Date) {
        self.userDate = date
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
    
    func onTrackerCreated(trackerID: UUID, categoryID: UUID) {
        updatePlaceholderState(TrackersPlaceholder.emptyResults)
        if presentedTrackerPacks.isEmpty {
            updateData()
            return
        }
        guard let newTracker = dataProcessor.fetchTrackerByID(trackerID) else { return }
        let presentedTrackers = provideTrackersByFilter()
        
        var isСontains = false
        for tracker in presentedTrackers where tracker.id == trackerID { isСontains = true }
        if !isСontains { return }
        
        var insertedIndexPath: IndexPath?
    
        for packIndex in 0 ... presentedTrackerPacks.count - 1 where presentedTrackerPacks[packIndex].categoryID == categoryID {
            presentedTrackerPacks[packIndex].trackers.append(newTracker)
            insertedIndexPath = IndexPath(
                item: presentedTrackerPacks[packIndex].trackers.count - 1,
                section: packIndex
            )
            break
        }
        guard let insertedIndexPath else {
            updateData()
            return
        }
        updateTrackers?(UpdateOptions(insertedIndexPaths: [insertedIndexPath]))
    }
    
    func onTrackerModified(trackerID: UUID, categoryID: UUID) {
        guard let tracker = dataProcessor.fetchTrackerByID(trackerID),
              let indexPath = provideIdexPath(id: trackerID) else { return }
        
        presentedTrackerPacks[indexPath.section].trackers[indexPath.item] = tracker
        updateTrackers?(UpdateOptions(insertedIndexPaths: [indexPath]))
    }
    
    func onRecordTracker(id: UUID) {
        let updatedCompletedStatus = !dataProcessor.fetchTrackerCompletionForDate(
                trackerID: id,
                where: userDate
            )

        let _ = updatedCompletedStatus
            ? dataProcessor.addRecord(for: id, date: userDate)
            : dataProcessor.removeRecord(for: id, date: userDate)
        
        if currentFilter == .completedTrackers || currentFilter == .uncompletedTrackers {
            updateData()
            return
        }
        
        guard let trackerIndexPath = provideIdexPath(id: id) else {
            updateData()
            return
        }
        updateTrackers?(UpdateOptions(updatedIndexPath: trackerIndexPath))
    }
    
    func onPinnedTracker(for indexPath: IndexPath) {
        let tracker = presentedTrackerPacks[indexPath.section].trackers.remove(at: indexPath.item)
        
        let updatedPinnedStatus = !dataProcessor.fetchPinnedStatus(trackerID: tracker.id)
        if updatedPinnedStatus { dataProcessor.pinTracker(id: tracker.id) }
        if !updatedPinnedStatus { dataProcessor.unpinTracker(id: tracker.id) }
        
        if presentedTrackerPacks[indexPath.section].trackers.isEmpty || dataProcessor.fetchPinnedTrackers().count == 1 {
            updateData()
            return
        }
        
        var insertedIndexPath: IndexPath?
        
        if updatedPinnedStatus {
            presentedTrackerPacks[0].trackers.append(tracker)
            
            insertedIndexPath = IndexPath(
                item: presentedTrackerPacks[0].trackers.count - 1,
                section: 0
            )
        }
        if !updatedPinnedStatus {
            if let ownCategoryID = dataProcessor.fetchCategoryIDByTrackerID(tracker.id) {
                for packIndex in 0 ... presentedTrackerPacks.count - 1 where presentedTrackerPacks[packIndex].categoryID == ownCategoryID {
                    presentedTrackerPacks[packIndex].trackers.append(tracker)
                    insertedIndexPath = IndexPath(
                        item: presentedTrackerPacks[packIndex].trackers.count - 1,
                        section: packIndex
                    )
                    break
                }
            }
        }
        
        guard let insertedIndexPath else {
            updateData()
            return
        }
        
        updateTrackers?(UpdateOptions(
            insertedIndexPaths: [insertedIndexPath],
            deletedIndexPaths: [indexPath]
        ))
    }
    
    func onRemoveTracker(for indexPath: IndexPath) {
        let tracker = presentedTrackerPacks[indexPath.section].trackers.remove(at: indexPath.item)
        dataProcessor.removeTracker(id: tracker.id)
        
        if presentedTrackerPacks[indexPath.section].trackers.isEmpty {
            updateData()
            return
        }
        
        updateTrackers?(UpdateOptions(deletedIndexPaths: [indexPath]))
        setPlaceholderState()
    }
    
//MARK: - ScreenDataSource aka Fetch Result Controller
    func sectionsCount() -> Int {
        presentedTrackerPacks.count
    }
    
    func itemsCount(for section: Int) -> Int {
        if section < 0 || section > presentedTrackerPacks.count - 1 { return 0 }
        return presentedTrackerPacks[section].trackers.count
    }
    
    func sectionTitle(for indexPath: IndexPath) -> String? {
        if indexPath.section < 0 || indexPath.section > presentedTrackerPacks.count - 1 { return nil }
        return presentedTrackerPacks[indexPath.section].title
    }
    
    func object(for indexPath: IndexPath) -> TrackerScreenModel? {
        if indexPath.section < 0 || indexPath.section > presentedTrackerPacks.count - 1 { return nil }
        
        let presentedTrackerPack = presentedTrackerPacks[indexPath.section]
        if indexPath.item < 0 || indexPath.item > presentedTrackerPack.trackers.count - 1 { return nil }
        
        return provideTrackerScreenModel(for: presentedTrackerPack.trackers[indexPath.item])
    }
    
//MARK: - Observers
    func observeUpdateTrackers(_ completion: @escaping (UpdateOptions) -> Void) {
        updateTrackers = completion
    }
    
    func observePlaceholderState(_ completion: @escaping (TrackersPlaceholder.State?) -> Void) {
        placeholderState.observe(completion)
    }
    
//MARK: - private funcs
    private func updateData() {
        presentedTrackerPacks = providePresentedPacks()
        updateTrackers?(UpdateOptions(isReload: true))
    }
    
    private func providePresentedPacks() -> [TrackersPackData] {
        var resultPacks = [TrackersPackData?]()
        let trackers = provideTrackersByFilter()
        let trackersPacks = dataProcessor.fetchPacksForTrackers(for: trackers)
                
        resultPacks.append(contentsOf: trackersPacks.map{
            providePackData(for: $0, from: trackers)
        })
        resultPacks = resultPacks.compactMap{$0}.sorted()
        
        let pinnedTrackers = dataProcessor.fetchPinnedTrackers()
        if !pinnedTrackers.isEmpty {
            let pinnedTrackersPack = TrackersPackData(
                title: "Закрепленные",
                categoryID: nil,
                trackers: pinnedTrackers
            )
            resultPacks.insert(pinnedTrackersPack, at: 0)
        }
        
        return resultPacks.compactMap{$0}
    }
    
    private func provideTrackersByFilter() -> [TrackerModel] {
        var trackers = [TrackerModel]()
        
        switch currentFilter {
        case .allTrackers:
            trackers = dataProcessor.fetchAllTrackers()
        case .todayTrackers:
            trackers = dataProcessor.fetchTrackersForRequiredDate(where: userDate)
        case .completedTrackers:
            trackers = dataProcessor.fetchTrackersOnRequiredDateOfCompletedState(
                requiredDate: userDate,
                isCompleted: true
            )
        case .uncompletedTrackers:
            trackers = dataProcessor.fetchTrackersOnRequiredDateOfCompletedState(
                requiredDate: userDate,
                isCompleted: false
            )
        }
        
        if currentRequiredTrackerSubTitle.isEmpty { return trackers }
        
        return dataProcessor.fetchTrackersWhereSubTitles(
            from: trackers,
            where: currentRequiredTrackerSubTitle
        )
    }
    
    private func providePackData(
        for trackersPack: TrackersPack,
        from trackers: [TrackerModel]
    ) -> TrackersPackData? {
        var presentedTracker = [TrackerModel]()
        
        if trackersPack.trackerIDList.isEmpty || trackers.isEmpty { return nil }
            
        for trackerIDInPack in trackersPack.trackerIDList {
            for tracker in trackers where trackerIDInPack == tracker.id {
                if !dataProcessor.fetchPinnedStatus(trackerID: tracker.id) {
                    presentedTracker.append(tracker)
                }
            }
        }
        
        if presentedTracker.isEmpty { return nil }
        
        return TrackersPackData(
            title: dataProcessor.fetchTitleByCategoryID(trackersPack.categoryID),
            categoryID: trackersPack.categoryID,
            trackers: presentedTracker
        )
    }
    
    private func provideTrackerScreenModel(for tracker: TrackerModel) -> TrackerScreenModel {
        DataConverter.map(
            tracker: tracker,
            daysCount: dataProcessor.fetchTrackerCompletionCount(
                trackerID: tracker.id
            ),
            isCompleted: dataProcessor.fetchTrackerCompletionForDate(
                trackerID: tracker.id,
                where: userDate
            ),
            isAvailable: DateFormatterObj.shared.convertToInt(userDate) <= DateFormatterObj.shared.convertToInt(Date()),
            isPinned: dataProcessor.fetchPinnedStatus(trackerID: tracker.id)
        )
    }
    
    private func provideIdexPath(id: UUID) -> IndexPath? {
        if presentedTrackerPacks.isEmpty { return nil }
     
        for packIndex in 0 ... presentedTrackerPacks.count - 1 {
            if presentedTrackerPacks[packIndex].trackers.isEmpty { continue }
            for trackerIndex in 0 ... presentedTrackerPacks[packIndex].trackers.count - 1 where presentedTrackerPacks[packIndex].trackers[trackerIndex].id == id {
                return IndexPath(item: trackerIndex, section: packIndex)
            }
        }
        return nil
    }
    
    private func setPlaceholderState() {
        switch dataProcessor.fetchAllTrackers().isEmpty {
        case true: updatePlaceholderState(TrackersPlaceholder.noContent)
        case false: updatePlaceholderState(TrackersPlaceholder.emptyResults)
        }
    }
    
    private func updatePlaceholderState(_ requiredState: TrackersPlaceholder.State) {
        guard let curentState = placeholderState.value else {
            placeholderState.postValue(requiredState)
            return
        }
        if curentState.id != requiredState.id { placeholderState.postValue(requiredState) }
    }
}
