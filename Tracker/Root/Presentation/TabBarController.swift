import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        tabBar.backgroundColor = .ypWhite
        
        let borderLine = UIView()
        borderLine.backgroundColor = .ypTabBarBorder
        tabBar.addSubView(
            borderLine, heigth: 0.4,
            top: AnchorOf(tabBar.topAnchor),
            leading: AnchorOf(tabBar.leadingAnchor),
            trailing: AnchorOf(tabBar.trailingAnchor)
        )
                
        let trackersListViewController = TrackersViewController()
        trackersListViewController.inaccessibleViews.append(self)
        trackersListViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackersInactive"),
            selectedImage: UIImage(named: "TrackersActive")
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticInactive"),
            selectedImage: UIImage(named: "StatisticActive")
        )
        
        self.viewControllers = [trackersListViewController, statisticViewController]
    }
}

extension TabBarController: ViewVisibilityProtocol {
    func show() {
        tabBar.isHidden = false
    }
    
    func hide() {
        tabBar.isHidden = true
    }
}
