//
//  TabBarController.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    private var refreshLaunch = true
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setTabBar()
        setupStyle()
    }
    
    // MARK: - Custom Methods
    
    private func setViewControllers() {
        
        let bookShelfNVC = makeNavigationController(
            
            unselectedImage: ImageLiterals.TabBar.bookshelf,
            selectedImage: ImageLiterals.TabBar.bookshelfSelected,
            rootViewController: BookShelfVC(), title: I18N.Tabbar.bookshelf)
        
        let recommendNVC = makeNavigationController(
            unselectedImage: ImageLiterals.TabBar.recommend,
            selectedImage: ImageLiterals.TabBar.recommendSelected,
            rootViewController: RecommendVC(), title: I18N.Tabbar.recommend)
        
        let myPageNVC = makeNavigationController(
            unselectedImage: ImageLiterals.TabBar.myPage,
            selectedImage: ImageLiterals.TabBar.myPageSelected,
            rootViewController: MyPageVC(), title: I18N.Tabbar.mypage)
        
        viewControllers = [bookShelfNVC, recommendNVC, myPageNVC]
    }
    
    private func setTabBar() {        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .peekaRed
        tabBar.unselectedItemTintColor = .peekaGray1
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
        nav.tabBarItem.setTitleTextAttributes([.font: UIFont.font(.notoSansMedium, ofSize: 11)], for: .normal)
        nav.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        nav.navigationItem.backBarButtonItem?.tintColor = .black
        
        nav.interactivePopGestureRecognizer?.isEnabled = true
        nav.interactivePopGestureRecognizer?.delegate = self
        return nav
    }
    
    private func setupStyle() {
        clearShadow()
        tabBar.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 0, blur: 10)
    }
    
    private func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    func changeRecommendTab() {
        if refreshLaunch == true {
            refreshLaunch = false
            selectedIndex = 2
        }
    }
}

extension TabBarController: UIGestureRecognizerDelegate { }
