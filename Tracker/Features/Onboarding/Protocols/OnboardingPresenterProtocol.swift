import Foundation

protocol OnboardingPresenterProtocol {
    func getDismissedStatus() -> Bool
    func saveDismissedStatus(_ isDismissed: Bool)
}
