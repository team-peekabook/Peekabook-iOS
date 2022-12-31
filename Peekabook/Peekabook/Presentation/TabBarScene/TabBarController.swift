//
//  TabBarController.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
    }
    
    // MARK: - Custom Methods
    
    private func setViewControllers() {
        
        let bookShelfNVC = makeNavigationController(
            
            unselectedImage: UIImage(named: "icn_bookshelf"),
            selectedImage: UIImage(named: "icn_bookshelf_fill"),
            rootViewController: BookShelfVC(), title: "책장")
        
        let recommendNVC = makeNavigationController(
            unselectedImage: UIImage(named: "icn_recom"),
            selectedImage: UIImage(named: "icn_recom_fill"),
            rootViewController: RecommendVC(), title: "추천")
        
        let myPageNVC = makeNavigationController(
            unselectedImage: UIImage(named: "icn_my"),
            selectedImage: UIImage(named: "icn_my_fill"),
            rootViewController: MyPageVC(), title: "MY")
        
        viewControllers = [bookShelfNVC, recommendNVC, myPageNVC]
    }
    
    private func setTabBar() {
        let appearance = UITabBar.appearance()
        
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.clipsToBounds = true
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 0.565, green: 0.169, blue: 0.129, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor(red: 0.642, green: 0.642, blue: 0.642, alpha: 1)
    }
    
    private func makeNavigationController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController, title: String) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        nav.navigationBar.tintColor = .black
        nav.navigationBar.backgroundColor = .white
        nav.isNavigationBarHidden = true
        nav.navigationBar.isHidden = true
        
        nav.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        nav.navigationItem.backBarButtonItem?.tintColor = .black
        return nav
    }
}