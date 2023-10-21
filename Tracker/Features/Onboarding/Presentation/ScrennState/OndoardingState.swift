import UIKit

final class OnboardingState {
    static let page1 = State(
        background: UIImage(named: "OnboardingBackground_1"),
        message: "Отслеживайте только\nто, что хотите",
        pageGroup: UIImage(named: "OB_swipe_1")
    )
    
    static let page2 = State(
        background: UIImage(named: "OnboardingBackground_2"),
        message: "Даже если это\nне литры воды и йога",
        pageGroup: UIImage(named: "OB_swipe_2")
    )
    
    struct State {
        let background: UIImage?
        let message: String
        let pageGroup: UIImage?
    }
}
