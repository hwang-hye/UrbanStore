//
//  TabBarController.swift
//  UrbanStore
//
//  Created by hwanghye on 6/17/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .gray

        let search = MainViewController()
        let navSearch = UINavigationController(rootViewController: search)
        navSearch.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let setting = SettingViewController()
        let navSetting = UINavigationController(rootViewController: setting)
        navSetting.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 0)
        
        setViewControllers([navSearch, navSetting], animated: true)
    }
}
