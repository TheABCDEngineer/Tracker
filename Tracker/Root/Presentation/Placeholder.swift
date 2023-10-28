import UIKit

final class Placeholder {
    let view = UIView()
    
    let image = UIImageView()
    
    let label = UILabel()
    
    var wigth: CGFloat {
        get {
            return view.frame.width
        } set {
            view.frame = CGRect(
                x: view.frame.minX,
                y: view.frame.minY,
                width: newValue,
                height: view.frame.height
            )
        }
    }
    
    var height: CGFloat {
        get {
            return view.frame.height
        } set {
            view.frame = CGRect(
                x: view.frame.minX,
                y: view.frame.minY,
                width: view.frame.width,
                height: newValue
            )
        }
    }
    
    init() {
        view.addSubView(
            image,
            top: AnchorOf(view.topAnchor),
            centerX: AnchorOf(view.centerXAnchor)
        )
        
        view.addSubView(
            label,
            top: AnchorOf(image.bottomAnchor, 8),
            centerX: AnchorOf(view.centerXAnchor)
        )
        
        label.numberOfLines = 2
        label.textAlignment = .center
    }
}
