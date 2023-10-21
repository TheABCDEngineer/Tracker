import Foundation

final class Creator {
//MARK: - Presenters injections
    static func injectOnboardingPresenter() -> OnboardingPresenterProtocol {
        return OnboardingPreseter(
            onboardingStatusRepository: injectOnboardingRepository()
        )
    }
    
//MARK: - Repositories injections
    static func injectOnboardingRepository() -> OnboardingRepository {
        return OnboardingRepositoryImplUserDefaults()
    }
}
