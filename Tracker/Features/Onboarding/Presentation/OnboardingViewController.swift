import UIKit

final class OnboardingViewController: UIPageViewController {
    private let viewModel = Creator.injectOnboardingViewModel()
    private var pages = [OnboardingPageViewController]()
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if viewModel.getDismissedStatus() { switchToMainController() }
        
        configurePages()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        configureParentLayout()
    }
    
    @objc
    private func onButtonClick() {
        viewModel.saveDismissedStatus(true)
        switchToMainController()
    }
    
    private func switchToMainController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration when switch to TabBarController")
            return
        }
        window.rootViewController = TabBarController()
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingPageViewController)
        else {
            return nil
        }
                
        let previousIndex = viewControllerIndex - 1
                
        guard previousIndex >= 0 else { return nil }
                
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingPageViewController)
        else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
                
        guard nextIndex < pages.count else { return nil }
                
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - Config
extension OnboardingViewController {
    private func configurePages() {
        let page1 = OnboardingPageViewController()
        page1.setScreenState(with: OnboardingState.page1)
        
        let page2 = OnboardingPageViewController()
        page2.setScreenState(with: OnboardingState.page2)
        
        pages.append(contentsOf: [page1, page2])
    }
    
    private func configureParentLayout() {
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
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        view.addSubView(
            pageControl,
            bottom: AnchorOf(button.topAnchor, -24),
            centerX: AnchorOf(view.centerXAnchor)
        )
    }
}
