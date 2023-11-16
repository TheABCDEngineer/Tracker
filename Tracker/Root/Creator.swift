import Foundation

final class Creator {
//MARK: - Presenters injections
    static func injectOnboardingPresenter() -> OnboardingPresenterProtocol {
        return OnboardingPreseter(
            onboardingStatusRepository: injectOnboardingRepository()
        )
    }
    
    static func injectTrackerCreatorPresenter() -> TrackerCreatorPresenter {
        return TrackerCreatorPresenter(
            trackersRepository: injectTrackersRepository(),
            packRepository: injectCategoryTrackersPackRepository()
        )
    }
    
    static func injectSchedulerPresenter() -> SchedulerPresenter {
        return SchedulerPresenter()
    }
    
    static func injectCategorySetterPresenter() -> CategorySetterPresenter {
        return CategorySetterPresenter(
            categoryRepository: injectTrackerCategoryRepository()
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
    
    static func injectCategoryTrackersPackRepository() -> CategoryTrackerPackRepository {
        return CategoryTrackerPackRepositoryImplUserDef()
    }
}
