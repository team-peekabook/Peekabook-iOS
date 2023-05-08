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
        // White non-translucent bar, supports dark appearance
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .peekaBeige
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        KakaoSDK.initSDK(appKey: "be7076a55a9cc042dec5c83265a03e91")
        
        let defaults = UserDefaults.standard
        let accessToken = Config.accessToken
        let userManager = UserManager.shared
        
        print("✅✅✅!! 유저디폴트로 바꾼 경우 !!!✅✅✅")
        print(defaults.bool(forKey: "isSignedUpComplete"))
        if let accessToken = defaults.string(forKey: "accessToken") {
            print(accessToken)
        }
        if let refreshToken = defaults.string(forKey: "refreshToken") {
            print(refreshToken)
        }
//        print(defaults.string(forKey: "accessToken"))
//        print(defaults.string(forKey: "refreshToken"))
        print("--------------------    AppDelegate    ------------------------")
        
        print("✅✅✅!! Config로 바꾼 경우 !!!✅✅✅")
        
        print(Config.accessToken)
        print(Config.isSignedUp)
        
        print("--------------------    AppDelegate    ------------------------")
        
        if defaults.bool(forKey: "isSignedUpComplete") {
            let rootViewController = TabBarController()
            window?.rootViewController = rootViewController
            Config.accessToken = accessToken
            window?.makeKeyAndVisible()
        } else {
            let loginViewController = OnboardingVC()
            window?.rootViewController = loginViewController
            window?.makeKeyAndVisible()
        }
        
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
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

