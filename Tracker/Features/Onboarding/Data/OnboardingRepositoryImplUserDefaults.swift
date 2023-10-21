import Foundation

final class OnboardingRepositoryImplUserDefaults: OnboardingRepository {
    let repository = UserDefaults.standard
    let key = "OnboardingStatus"
    
    func putStatus(_ isRequired: Bool) {
        repository.set(isRequired, forKey: key)
    }
    
    func getStatus() -> Bool {
        return repository.bool(forKey: key)
    }
    
    
}
