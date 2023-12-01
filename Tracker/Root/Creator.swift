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
        return TrackerCategoryRepositoryImplUserDef.shared
    }
    
    static func injectTrackersRepository() -> TrackersRepository {
        return TrackersRepositoryImplUserDef.shared
    }
    
    static func injectTrackersPackRepository() -> TrackersPackRepository {
        return TrackersPackRepositoryImplUserDef()
    }
    
    static func injectTrackerRecordsRepository() -> TrackerRecordsRepository {
        return TrackerRecordsRepositoryImplUserDef()
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
    
    static func injectCoreDataContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
//MARK: - Value Transformers registration
    static func registrateValueTransformers() {
        TrackerTypeValueTransformer.register()
        ScheduleValueTransformer.register()
        ColorValueTransformer.register()
        SetOfIntegerValueTransformer.register()
        SetOfDatesValueTransformer.register()
    }
}
