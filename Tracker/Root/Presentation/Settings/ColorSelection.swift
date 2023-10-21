import UIKit

struct Selection {
    static let color: [UIColor] = getColorSet()
    
    private static func getColorSet() -> [UIColor] {
        var colors = [UIColor]()
        for i in 1...18 {
            let color = "Selection \(i)"
            colors.append(UIColor(named: color) ?? UIColor.systemFill)
        }
        return colors
    }
}
