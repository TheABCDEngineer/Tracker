import UIKit

final class OnboardingState {
    static let page1 = State(
        background: UIImage(named: "OnboardingBackground_1"),
        message: localized("onboarding.page1")
    )
    
    static let page2 = State(
        background: UIImage(named: "OnboardingBackground_2"),
        message: localized("onboarding.page2")
    )
    
    struct State {
        let background: UIImage?
        let message: String
    }
}
