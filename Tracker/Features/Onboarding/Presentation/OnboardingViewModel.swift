import Foundation

final class OnboardingViewModel: OnboardingViewModelProtocol {
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
