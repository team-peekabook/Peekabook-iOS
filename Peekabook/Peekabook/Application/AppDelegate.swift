//
//  AppDelegate.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/29.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
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
        
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        FirebaseApp.configure()
        setupFCM(application)
        
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
    
    private func setupFCM(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { isAgree, error in
            if isAgree {
                print("알림허용")
            }
        }
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    /// 푸시클릭시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("🟢", #function)
    }
    
    /// 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("🟢", #function)
        return [.sound, .banner, .list]
    }
    
    /// FCMToken 업데이트시
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🟢", #function, fcmToken)
    }
    
    /// 스위즐링 NO시, APNs등록, 토큰값가져옴
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("🟢", #function, deviceTokenString)
    }
    
    /// error발생시
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🟢", error)
    }
}
