//
//  RootTabBarViewController.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-16.
//

import Foundation
import UIKit

class RootTabBarController: UITabBarController {
    let viewModel = DataListViewModel(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let sampleViewController = ViewController()
//        let sampleViewTabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
//        sampleViewController.tabBarItem = sampleViewTabBarItem
        
        let dataListViewContrller = UINavigationController(rootViewController: DataListViewController(viewModel: viewModel))
        let analysisViewController = UINavigationController(rootViewController: AnalysisViewController(viewModel: viewModel))
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController(viewModel: viewModel))
        let dataListViewTabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)
        let analysisViewTabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        let settingsViewTabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        dataListViewContrller.tabBarItem = dataListViewTabBarItem
        analysisViewController.tabBarItem = analysisViewTabBarItem
        settingsViewController.tabBarItem = settingsViewTabBarItem
        
        self.viewControllers = [dataListViewContrller, analysisViewController, settingsViewController]
        
    }
}
