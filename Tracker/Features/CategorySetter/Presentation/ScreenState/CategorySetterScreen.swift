import Foundation

final class CategorySetterScreen {
    
    static let noEnyCategories = State(
        placeholderVisibility: true
    )
    
    static let someCategories = State(
        placeholderVisibility: false
    )
    
    struct State {
        let placeholderVisibility: Bool
    }
}
