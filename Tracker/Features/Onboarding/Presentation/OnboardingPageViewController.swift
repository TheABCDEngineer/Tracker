import UIKit

class OnboardingPageViewController: UIViewController {
    private let backgroundView = UIImageView()
    private let messageView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubView(
            backgroundView,
            top: AnchorOf(view.topAnchor),
            bottom: AnchorOf(view.bottomAnchor),
            leading: AnchorOf(view.leadingAnchor),
            trailing: AnchorOf(view.trailingAnchor)
        )
        
        messageView.textColor = .black
        messageView.font = Font.ypBold32
        messageView.numberOfLines = 2
        messageView.textAlignment = .center
        view.addSubView(
            messageView,
            bottom: AnchorOf(view.bottomAnchor, -304),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
    }
    
    func setScreenState(with state: OnboardingState.State) {
        backgroundView.image = state.background
        messageView.text = state.message
    }
}
