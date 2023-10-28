import UIKit

final class BottomSheet {
    
    let view = UIView()
    
    var startHeight: CGFloat {
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
    
    var cornerRadius: CGFloat {
        get {
            return view.layer.cornerRadius
        } set {
            view.layer.cornerRadius = newValue
        }
    }
    
    var backgroundColor: UIColor {
        get {
            return view.backgroundColor ?? UIColor.clear
        } set {
            view.backgroundColor = newValue
        }
    }
    
    private let superView: UIView
    
    private let cover = UIView()
    
    private var viewsAboveSuperView: [ViewVisibilityProtocol] = []
    
    init(
        with superView: UIView,
        viewsAboveSuperView: [ViewVisibilityProtocol] = []
    ) {
        self.superView = superView
        self.viewsAboveSuperView.append(contentsOf: viewsAboveSuperView)
        
        initiateLayouts()
        configureSwipe(direction: .down)
    }
        
    func show() {
        getBottomSheetViewOnTop()
        hideViewsUnderSuperView()
        cover.isHidden = false
        animate(isHiden: false)
    }
    
    func hide() {
        animate(isHiden: true) {
            self.cover.isHidden = true
            self.showViewsUnderSuperView()
        }
    }
        
    private func initiateLayouts() {
        cover.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0)
        cover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverTap)))
        cover.isHidden = true
        addCover()
        
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 100)
        superView.addSubview(view)
    }
    
    private func addCover() {
        superView.addSubView(
            cover,
            top: AnchorOf(superView.topAnchor),
            bottom: AnchorOf(superView.bottomAnchor),
            leading: AnchorOf(superView.leadingAnchor),
            trailing: AnchorOf(superView.trailingAnchor)
        )
    }
    
    
    private func configureSwipe(direction: UISwipeGestureRecognizer.Direction) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipe.direction = direction
        view.addGestureRecognizer(swipe)
    }
    
    @objc
    private func coverTap() { hide() }
    
    @objc
    private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .down:
            hide()
        default:
            return
        }
    }
    
    private func getBottomSheetViewOnTop() {
        if superView.subviews[superView.subviews.count - 1] == view { return }
        view.removeFromSuperview()
        cover.removeFromSuperview()
        
        addCover()
        superView.addSubview(view)
    }
    
    private func showViewsUnderSuperView() {
        if viewsAboveSuperView.isEmpty {return}
        for view in viewsAboveSuperView {
            view.show()
        }
    }
    
    private func hideViewsUnderSuperView() {
        if viewsAboveSuperView.isEmpty {return}
        for view in viewsAboveSuperView {
            view.hide()
        }
    }
    
    private func animate(
        isHiden: Bool,
        completion: @escaping () -> Void = {}
    ) {
        let duration: TimeInterval = 0.2
        var heigth: CGFloat = UIScreen.main.bounds.height - startHeight + cornerRadius
        var alpha: CGFloat = 0.5
        
        if isHiden {
            heigth = UIScreen.main.bounds.height
            alpha = 0
        }
        
        UIView.animate(withDuration: duration) {
            self.view.frame = CGRect(
                x: 0,
                y: heigth,
                width: self.view.frame.width,
                height: self.view.frame.height
            )
        }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.cover.backgroundColor = UIColor(
                    red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: alpha
                )
            },
            completion: { _ in
                completion()
            }
        )
    }
}
