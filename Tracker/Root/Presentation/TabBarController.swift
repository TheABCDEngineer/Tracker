import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let trackersListViewController = storyboard.instantiateViewController(
            withIdentifier: "TrackersViewController"
        )
        
        trackersListViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackersInactive"),
            selectedImage: UIImage(named: "TrackersActive")
        )
        
        let statisticViewController = storyboard.instantiateViewController(
            withIdentifier: "StatisticViewController"
        )
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticInactive"),
            selectedImage: UIImage(named: "StatisticActive")
        )

        self.viewControllers = [trackersListViewController, statisticViewController]
    }
}
