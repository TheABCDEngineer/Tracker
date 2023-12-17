import Foundation

protocol OnboardingViewModelProtocol {
    func getDismissedStatus() -> Bool
    func saveDismissedStatus(_ isDismissed: Bool)
}
