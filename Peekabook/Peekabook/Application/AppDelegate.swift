//
//  AppDelegate.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/29.
//

import UIKit
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .peekaBeige
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        checkAppVersionOnAppLaunch()
        
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        //        if #available(iOS 15, *) {
        //            let appearance = UITabBarAppearance()
        //            appearance.configureWithOpaqueBackground()
        //            appearance.backgroundColor = .white
        //            UITabBar.appearance().standardAppearance = appearance
        //            UITabBar.appearance().scrollEdgeAppearance = appearance
        //        }
        Thread.sleep(forTimeInterval: 1.0)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
    
    func checkAppVersionOnAppLaunch() {
        AppVersionCheck.checkAppVersion { needsUpdate in
            DispatchQueue.main.async {
                if needsUpdate {
                    let forceUpdateVC = ForceUpdateVC()
                    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }
                    rootViewController.present(forceUpdateVC, animated: false, completion: nil)
                }
            }
        }
    }
}
