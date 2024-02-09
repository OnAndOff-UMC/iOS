//
//  AppDelegate.swift
//  On_off_iOS
//
//  Created by 정호진 on 12/31/23.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        
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

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("파이어베이스 토큰: \(fcmToken ?? "")")
        guard let fcmToken = fcmToken else { return }
//        _ = KeychainWrapper.saveItem(value: fcmToken, forKey: "DeviceToken")
//        
//        let loginService = SignInService()
//        _ = loginService.updateFCMDeviceToken(fcmToken: fcmToken)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 푸시알림이 수신되었을 때 수행되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("메시지 수신 \(#function)")
        print(notification, center)
        completionHandler([.badge, .sound, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Start😡")
        print(response.notification.request.content.title, response.notification.request.content.body)
        
        let userInfo = response.notification.request.content.userInfo
        let type = "\(response.notification.request.content.body.split(separator: " ")[0])"
        let id = userInfo.filter { "\($0.key)" == "id" }
        
        print("type: \(type)")
        
        guard let value = id.first?.value else { return }
        print("value \(value)")
        NotificationCenter.default.post(name: Notification.Name("showPage"),
                                        object: nil,
                                        userInfo: ["index": 1, "id": value, "type": type,
                                                   "title": response.notification
                                            .request.content.title,
                                                   "body": response.notification
                                            .request.content.body])
        
        userInfo.forEach { (key: AnyHashable, value: Any) in
            print(key, value)
        }
        
        print("END😡")
        completionHandler()
    }
}

