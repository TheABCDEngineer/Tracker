import UIKit

final class ApplyButton {
    static let active = State(
        isEnabled: true,
        color: .ypBlack
    )
    
    static let inactive = State(
        isEnabled: false,
        color: .ypGray
    )
    
    struct State {
        let isEnabled: Bool
        let color: UIColor
    }
}
