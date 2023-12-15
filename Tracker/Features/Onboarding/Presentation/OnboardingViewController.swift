import UIKit

final class OnboardingViewController: UIViewController {
    private let viewModel = Creator.injectOnboardingViewModel()
    private var backgroundView: UIImageView!
    private var messageView: UILabel!
    private var pageGroup: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.getDismissedStatus() { switchToMainController() }
        configureLayout()
        updateScreenState(with: OnboardingState.page1)
        configureSwipes(direction: .left)
        configureSwipes(direction: .right)
    }
    
    @objc
    private func onButtonClick() {
        viewModel.saveDismissedStatus(true)
        switchToMainController()
    }
    
    @objc
    private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            updateScreenState(with: OnboardingState.page2)
        case .right:
            updateScreenState(with: OnboardingState.page1)
        default:
            return
        }
    }
    
    private func configureSwipes(direction: UISwipeGestureRecognizer.Direction) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipe.direction = direction
        view.addGestureRecognizer(swipe)
    }
    
    private func updateScreenState(with state: OnboardingState.State) {
        backgroundView.image = state.background
        messageView.text = state.message
        pageGroup.image = state.pageGroup
    }
    
    private func switchToMainController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration when switch to TabBarController")
            return
        }
        window.rootViewController = TabBarController()
    }
    
    private func configureLayout() {
        backgroundView = UIImageView()
        view.addSubView(
            backgroundView,
            top: AnchorOf(view.topAnchor),
            bottom: AnchorOf(view.bottomAnchor),
            leading: AnchorOf(view.leadingAnchor),
            trailing: AnchorOf(view.trailingAnchor)
        )
        
        let button = UIButton.systemButton(
            with: UIImage(),
            target: nil,
            action: #selector(self.onButtonClick)
        )
        button.setTitle("Вот это технологии!", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        view.addSubView(
            button, width: 335, heigth: 60,
            bottom: AnchorOf(view.bottomAnchor, -84),
            centerX: AnchorOf(view.centerXAnchor)
        )
        
        messageView = UILabel()
        messageView.textColor = .black
        messageView.font = Font.ypBold32
        messageView.numberOfLines = 2
        messageView.textAlignment = .center
        view.addSubView(
            messageView,
            bottom: AnchorOf(button.topAnchor, -160),
            leading: AnchorOf(view.leadingAnchor, 16),
            trailing: AnchorOf(view.trailingAnchor, -16)
        )
        
        pageGroup = UIImageView()
        view.addSubView(
            pageGroup,
            bottom: AnchorOf(button.topAnchor, -24),
            centerX: AnchorOf(view.centerXAnchor)
        )
    }
}
