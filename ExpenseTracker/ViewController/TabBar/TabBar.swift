//
//  TabBar.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class TabBar: UITabBarController {
    
    private lazy var homeTabBarItem: UITabBarItem = {
        let homeTabBarItem = UITabBarItem()
        homeTabBarItem.image = UIImage(systemName: "house")
        return homeTabBarItem
    }()
    
    private lazy var chartTabBarItem: UITabBarItem = {
        let chartTabBarItem = UITabBarItem()
        chartTabBarItem.image = UIImage(systemName: "chart.bar.xaxis")
        return chartTabBarItem
    }()
    
    private lazy var settingsTabBarItem: UITabBarItem = {
        let settingsTabBarItem = UITabBarItem()
        settingsTabBarItem.image = UIImage(systemName: "gearshape.fill")
        return settingsTabBarItem
    }()

    private lazy var homeVC: UINavigationController = {
        let homeVc = UINavigationController(rootViewController: HomeVC())
        homeVc.tabBarItem = homeTabBarItem
        return homeVc
    }()
    
    private lazy var chartVC: UINavigationController = {
        let chartVC = UINavigationController(rootViewController: ChartVC())
        chartVC.tabBarItem = chartTabBarItem
        return chartVC
    }()
    
    private lazy var  settingsVC: UINavigationController = {
        let settingsVC = UINavigationController(rootViewController: SettingsVC())
        settingsVC.tabBarItem = settingsTabBarItem
        return settingsVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.tabBar.unselectedItemTintColor = .label
        tabBar.tabBar.barTintColor = UIColor.systemGroupedBackground
        tabBar.tabBar.backgroundColor = .systemBackground
        tabBar.viewControllers = [homeVC, chartVC, settingsVC]
        return tabBar
    }
    
}
