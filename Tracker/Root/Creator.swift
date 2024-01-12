import UIKit
import CoreData

final class Creator {
//MARK: - ViewModels injections
    static func injectOnboardingViewModel() -> OnboardingViewModelProtocol {
        return OnboardingViewModel(
            onboardingStatusRepository: injectOnboardingRepository()
        )
    }
    
    static func injectTrackersViewModel() -> TrackersViewModel {
        return TrackersViewModel(
            dataProcessor: injectTrackersDataProcessor()
        )
    }
    
    static func injectTrackerCreatorViewModel() -> TrackerCreatorViewModel {
        return TrackerCreatorViewModel(
            trackersRepository: injectTrackersRepository(),
            packRepository: injectTrackersPackRepository(),
            categoryRepository: injectTrackerCategoryRepository()
        )
    }
    
    static func injectSchedulerViewModel() -> SchedulerViewModel {
        return SchedulerViewModel()
    }
    
    static func injectCategoryViewModel() -> CategorySetterViewModel {
        return CategorySetterViewModel(
            trackerPackRepository: injectTrackersPackRepository(),
            dataProvider: injectCategoryDataProvider()
        )
    }
    
    static func injectCategoryCreatorViewModel() -> CategoryCreatorViewModel {
        return CategoryCreatorViewModel(
            categoryRepository: injectTrackerCategoryRepository()
        )
    }
    
    static func injectStatisticViewModel() -> StatisticViewModel {
        StatisticViewModel(
            statisticService: injectStatisticService()
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
    
    static func injectPinnedTrackersRepository() -> PinnedTrackersRepository {
        PinnedTrackersRepositoryImplUserDef()
    }
    
    static func injectStatisticRepository() -> StatisticRepository {
        StatisticRepositoryImplUserDef()
    }
    
//MARK: - Services injections
    static func injectTrackersDataProcessor() -> TrackersDataProcessorProtocol {
        return TrackersDataProcessorImpl(
            trackersRepository: injectTrackersRepository(),
            categoryRepository: injectTrackerCategoryRepository(),
            packRepository: injectTrackersPackRepository(),
            recordsRepository: injectTrackerRecordsRepository(),
            pinnedTrackersRepository: injectPinnedTrackersRepository(),
            statisticRepository: injectStatisticRepository()
        )
    }
    
    static func injectCategoryDataProvider() -> CategoryDataProviderProtocol {
        return CategoryDataProvider(
            context: injectCoreDataContext(),
            categoryRepository: injectTrackerCategoryRepository(),
            trackersPackRepository: injectTrackersPackRepository()
        )
    }
    
    static func injectStatisticService() -> StatisticServiceProtocol {
        StatisticServiceImpl(
            statisticRepository: injectStatisticRepository(),
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

//MARK: - Global funcs
func localized(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
    NSLocalizedString(
        key,
        tableName: tableName,
        bundle: bundle,
        value: value,
        comment: comment
    )
}
