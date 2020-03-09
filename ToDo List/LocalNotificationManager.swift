//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 3/9/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
import UserNotifications

struct LocalNotificationManager {
    static func authorizeLocalNotifications(viewController: UIViewController) {
           // UNUserNotificationCenter.current() ALWAYS GO TOGETHER
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
               //im gonna guard and make sure that the only thing is if error is nil and then im going to perform code in the else brackets
               guard error == nil else {
                   print("😡 ERROR: \(error!.localizedDescription)")
                   return
               }
               if granted {
                   print("✅ Notifications have been granted!")
               } else {
                   print("🚫 Notifications denied!")
                //STUFF IN DIPATCH RUNS ON THE MAIN THREAD, NOT THE BACKGROUND THREAD
                DispatchQueue.main.async {
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notications", message: "To receive alerts from reminders, open Settings App, select To Do List > Notifications > Allow Notifications.")
                }
               }
           }
       }
    
    static func isAuthorized(completed: @escaping (Bool)->() ) {
        // UNUserNotificationCenter.current() ALWAYS GO TOGETHER
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            //im gonna guard and make sure that the only thing is if error is nil and then im going to perform code in the else brackets
            guard error == nil else {
                print("😡 ERROR: \(error!.localizedDescription)")
                completed(false)
                return
            }
            if granted {
                print("✅ Notifications have been granted!")
                 completed(true)
            } else {
                print("🚫 Notifications denied!")
                 completed(false)
            }
        }
    }
    
    
   static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
           let content = UNMutableNotificationContent()
           content.title = title
           content.subtitle = subtitle
           content.body = body
           content.sound = sound
           content.badge = badgeNumber
           
           //create trigger
           
           var dateCompenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
           dateCompenents.second = 00
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompenents, repeats: false )
           //creating a request
           let notificationID = UUID().uuidString
           let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
           
           //regiester request with notification center
           
           UNUserNotificationCenter.current().add(request) { (error) in
               if let error = error {
                   print("😡ERROR: \(error.localizedDescription)")
               } else {
                   print("Notification scheduled \(notificationID), title: \(content.title)")
               }
           }
    
           return notificationID
       }
}
