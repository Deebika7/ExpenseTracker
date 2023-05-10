//
//  TabBar.swift
//  ExpenseTracker
//
//  Created by deebika-pt6680 on 09/05/23.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.tabBar.unselectedItemTintColor = .label
        let moneyTrackerVc = UINavigationController(rootViewController: MoneyTrackerVC())
        let chartVC = UINavigationController(rootViewController: PieChartVC())
        let settingsVC = UINavigationController(rootViewController: SettingsVC())
        moneyTrackerVc.tabBarItem = homeTabBarItem
        chartVC.tabBarItem = chartTabBarItem
        settingsVC.tabBarItem = settingsTabBarItem
        tabBar.viewControllers = [moneyTrackerVc, chartVC, settingsVC]
        return tabBar
    }
    
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
    
    
    
}
