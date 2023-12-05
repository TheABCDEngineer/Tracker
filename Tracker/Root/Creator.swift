import UIKit
import CoreData

final class Creator {
//MARK: - Presenters injections
    static func injectOnboardingPresenter() -> OnboardingPresenterProtocol {
        return OnboardingPreseter(
            onboardingStatusRepository: injectOnboardingRepository()
        )
    }
    
    static func injectTrackersPresenter() -> TrackersPresenter {
        return TrackersPresenter(
            dataProcessor: injectTrackersDataProcessor()
        )
    }
    
    static func injectTrackerCreatorPresenter() -> TrackerCreatorPresenter {
        return TrackerCreatorPresenter(
            trackersRepository: injectTrackersRepository(),
            packRepository: injectTrackersPackRepository(),
            categoryRepository: injectTrackerCategoryRepository()
        )
    }
    
    static func injectSchedulerPresenter() -> SchedulerPresenter {
        return SchedulerPresenter()
    }
    
    static func injectCategorySetterPresenter() -> CategorySetterPresenter {
        return CategorySetterPresenter(
            categoryRepository: injectTrackerCategoryRepository(),
            trackerPackRepository: injectTrackersPackRepository()
        )
    }
    
    static func injectCategoryCreatorPresenter() -> CategoryCreatorPresenter {
        return CategoryCreatorPresenter(
            categoryRepository: injectTrackerCategoryRepository()
        )
    }
    
//MARK: - Repositories injections
    static func injectOnboardingRepository() -> OnboardingRepository {
        return OnboardingRepositoryImplUserDefaults()
    }
    
    static func injectTrackerCategoryRepository() -> TrackerCategoryRepository {
        return TrackerCategoryRepositoryImplCoreData(context: injectCoreDataContext())
    }
    
    static func injectTrackersRepository() -> TrackersRepository {
        return TrackersRepositoryImplCoreData(context: injectCoreDataContext())
    }
    
    static func injectTrackersPackRepository() -> TrackersPackRepository {
        return TrackersPackRepositoryImplCoreData(context: injectCoreDataContext())
    }
    
    static func injectTrackerRecordsRepository() -> TrackerRecordsRepository {
        return TrackerRecordsRepositoryImplCoreData(context: injectCoreDataContext())
    }
    
//MARK: - Services injections
    static func injectTrackersDataProcessor() -> TrackersDataProcessorProtocol {
        return TrackersDataProcessorImpl(
            trackersRepository: injectTrackersRepository(),
            categoryRepository: injectTrackerCategoryRepository(),
            packRepository: injectTrackersPackRepository(),
            recordsRepository: injectTrackerRecordsRepository()
        )
    }
    
//MARK: - CoreData    
    static func injectCoreDataContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    static func saveCoreDataContex(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
}
