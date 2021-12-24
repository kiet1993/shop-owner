//
//  AppDelegate.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 06/05/2021.
//

import UIKit
import SVProgressHUD
import Firebase
import DropDown

typealias HUD = SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    // MARK: - Singleton
    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
        }
        return shared
    }()
    
    enum RootType {
        case splash
        case tabbar
        case login
    }
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        HUD.setDefaultMaskType(.clear)
        DropDown.startListeningToKeyboard()
        if !AccountManager.shared.shouldLogin {
            setRoot(type: .tabbar)
        } else {
            setRoot(type: .splash)
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                // We have permission!
            }
        }
        application.registerForRemoteNotifications()
        
        window?.makeKeyAndVisible()
        return true
    }
    
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("deviceToken = \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func setRoot(type: RootType) {
        switch type {
        case .splash:
            let splashVC = LaunchViewController()
            let navi = UINavigationController(rootViewController: splashVC)
            window?.rootViewController = navi
        case .login:
            let splashVC = LoginViewController()
             let navi = UINavigationController(rootViewController: splashVC)
            window?.rootViewController = navi
        case .tabbar:
            appCoordinator = AppCoordinator(window: window)
            appCoordinator.start()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Always call the completion handler when done.
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM token: \(String(describing: fcmToken ?? "NULL"))")
        if let fcmToken = fcmToken {
            if AccountManager.shared.accessToken != nil {
                APIRequest.regisFCMToken(fcmToken: fcmToken) { (result) in
                    switch result {
                    case .success(let registerResponse):
                        AccountManager.shared.uuidRegistFCMToken = registerResponse.uuid
                        print("Subcribe FCM token success!!!")
                    case .failure(let error):
                        print("Subcribe FCM token failed with error \(error.localizedDescription)!!!")
                    }
                }
            } else {
                AccountManager.shared.fcmToken = fcmToken
            }
        }
    }
}
