//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 3/9/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
  static func authorizeLocalNotifications() {
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
                   //TODO: Put an alert in here telling the user what to do
                   // putting todo in all caps puts a reminder in the jump bar
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
