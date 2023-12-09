//
//  TabBarController.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private enum TabBarItem: Int {
        case trackers
        case statistic
        
        var title: String {
            switch self {
            case .trackers:
                return NSLocalizedString("trackersTitle", comment: "Text displayed on empty state")
            case . statistic:
                return NSLocalizedString("statistics", comment: "Text displayed on empty state")
            }
        }
        
        var iconName: String {
            switch self {
            case .trackers:
                return "TrackersBarImage"
            case .statistic:
                return "StatisticBarImage"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.trackers, .statistic]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .trackers:
                let trackersViewController = TrackersViewController()
                return self.wrappedNavigationController(with: trackersViewController, title: $0.title)
                
            case .statistic:
                let statisticViewController = StatisticViewController()
                return self.wrappedNavigationController(with: statisticViewController, title: $0.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(named: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
    
    private func wrappedNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
    }
}
