import Foundation

protocol OnboardingRepository {
    func putStatus(_ isDismissed: Bool)
    func getStatus() -> Bool
}
