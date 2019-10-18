//
//  RemoteNotificationHandler.swift
//  
//
//

import UIKit
import UserNotifications

class RemoteNotificationHandler: NSObject, UNUserNotificationCenterDelegate {

    class func registerForRemoteNotification() {
        
        let application = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {
                    return
                }
                if granted {
                    application.registerForRemoteNotifications()
                }
                else {
                    //Handle user denying permissions..
                }
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    //@@@>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //@@@@@@@@ Handle your notification
    //@@@>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    class func receivedRemoteNotification(userInfo: [AnyHashable : Any]) {
        Debug.log("\(userInfo.debugDescription)")
    }
    
    class func getDeviceToken() -> String {
        var deviceToken = ""
        if let token = defaults.value(forKey: pDeviceToken) as? String {
            deviceToken = token
        }
        return deviceToken
    }
    
    
    //@@@>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    // [START ios_10_message_handling]
    // Receive displayed notifications for iOS 10 devices.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        

        RemoteNotificationHandler.receivedRemoteNotification(userInfo: userInfo)
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        RemoteNotificationHandler.receivedRemoteNotification(userInfo: userInfo)
        
        completionHandler()
    }
    
    
    class var isPushNotificationEnabled: Bool {
        guard let settings = UIApplication.shared.currentUserNotificationSettings
            else {
                return false
        }
        
        return UIApplication.shared.isRegisteredForRemoteNotifications
            && !settings.types.isEmpty
    }
}
