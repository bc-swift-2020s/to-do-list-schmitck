//
//  AppDelegate.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 2/8/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//
//MARK:- import UserNotifications
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     //This gives the notification center on the device the right to send messages that are sent and received by the app and respond to them
        UNUserNotificationCenter.current().delegate = self
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

//MARK:- Notification Extension Required
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        //this code is not necessary, but it gives you a heads up of when a notification is displayed and is going to be displayed soon
        let id = notification.request.identifier
        print("Received in=app notification with ID = \(id)")
            //removed delivered notifications because you do not want them lingering around in the notification queue
        //MARK:- LEGO PIECE
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        completionHandler([.alert,.sound])
    }
}
