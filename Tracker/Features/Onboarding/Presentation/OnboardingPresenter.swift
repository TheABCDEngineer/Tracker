import Foundation

final class OnboardingPreseter: OnboardingPresenterProtocol {
    private let onboardingStatusRepository: OnboardingRepository
    
    init(onboardingStatusRepository: OnboardingRepository) {
        self.onboardingStatusRepository = onboardingStatusRepository
    }
    
    func getDismissedStatus() -> Bool {
        return onboardingStatusRepository.getStatus()
    }
    
    func saveDismissedStatus(_ isDismissed: Bool) {
        onboardingStatusRepository.putStatus(isDismissed)
    }
    
    
}
