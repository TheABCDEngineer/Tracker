//import Foundation
//
//final class TrackersPresenter1 {
//    
//    private let recordsRepository: TrackerRecordsRepository
//        
//    private let dataProcessor: TrackersDataProcessorProtocol
//    
//    private var currentDate = Date()
//    
//    private let trackersPacksData = ObservableData<[TrackersPackScreenModel]>()
//    
//    private let modifiedTracker = ObservableData<TrackerScreenModel>()
//    
//    init(
//        recordsRepository: TrackerRecordsRepository,
//        dataProcessor: TrackersDataProcessorProtocol
//    ) {
//        self.recordsRepository = recordsRepository
//        self.dataProcessor = dataProcessor
//    }
//    
//    func onViewLoaded() {
//        trackersPacksData.postValue(
//            dataProcessor.provideScreenData(filterByDate: Date())
//        )
//    }
//    
//    func setUserDate(_ date: Date) {
//        self.currentDate = date
//        trackersPacksData.postValue(
//            dataProcessor.provideScreenData(filterByDate: date)
//        )
//    }
//    
//    func onTrackerChecked(tracker: TrackerScreenModel) {
//        var record: TrackerRecord?
//        let updatedCompletedStatus = !tracker.isCompleted
//        let trackerID = tracker.id
//
//        if updatedCompletedStatus {
//            record = recordsRepository.saveRecord(for: trackerID, date: currentDate)
//        } else {
//            recordsRepository.removeRecord(for: trackerID, date: currentDate)
//            record = recordsRepository.getRecordByTrackerID(
//                for: trackerID,
//                from: recordsRepository.loadRecords()
//            )
//        }
//        let completedDays = record?.dates.count ?? 0
//        
//        modifiedTracker.postValue(
//            dataProcessor.setCompletedStatus(
//                for: tracker,
//                completedDays: completedDays,
//                isCompleted: updatedCompletedStatus
//            )
//        )
//    }
//    
////MARK: - Observers
//    func ObserveTrackersPacks(_ completion: @escaping ([TrackersPackScreenModel]?) -> Void) {
//        trackersPacksData.observe(completion)
//    }
//    
//    func ObserveModifiedTracker(_ completion: @escaping (TrackerScreenModel?) -> Void) {
//        modifiedTracker.observe(completion)
//    }
//    
////MARK: - private funcs
//  
//}
