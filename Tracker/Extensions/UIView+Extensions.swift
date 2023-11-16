import UIKit

extension UIView {
    func addSubView(
        _ view: UIView,
        width: CGFloat? = nil,
        heigth: CGFloat? = nil,
        top: AnchorOf<NSLayoutYAxisAnchor>? = nil,
        bottom: AnchorOf<NSLayoutYAxisAnchor>? = nil,
        leading: AnchorOf<NSLayoutXAxisAnchor>? = nil,
        trailing: AnchorOf<NSLayoutXAxisAnchor>? = nil,
        centerX: AnchorOf<NSLayoutXAxisAnchor>? = nil,
        centerY: AnchorOf<NSLayoutYAxisAnchor>? = nil
    ) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        if let width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let heigth {
            view.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        }
        if let top {
            view.topAnchor.constraint(
                equalTo: top.equalViewAncor,
                constant: top.constant
            ).isActive = true
        }
        if let bottom {
            view.bottomAnchor.constraint(
                equalTo: bottom.equalViewAncor,
                constant: bottom.constant
            ).isActive = true
        }
        if let leading {
            view.leadingAnchor.constraint(
                equalTo: leading.equalViewAncor,
                constant: leading.constant
            ).isActive = true
        }
        if let trailing {
            view.trailingAnchor.constraint(
                equalTo: trailing.equalViewAncor,
                constant: trailing.constant
            ).isActive = true
        }
        if let centerX {
            view.centerXAnchor.constraint(
                equalTo: centerX.equalViewAncor,
                constant: centerX.constant
            ).isActive = true
        }
        if let centerY {
            view.centerYAnchor.constraint(
                equalTo: centerY.equalViewAncor,
                constant: centerY.constant
            ).isActive = true
        }
    }
}

struct AnchorOf<AnchorType> {
    let equalViewAncor: AnchorType
    let constant: CGFloat
    
    init(_ equalViewAncor: AnchorType, _ constant: CGFloat = 0) {
        self.equalViewAncor = equalViewAncor
        self.constant = constant
    }
}
