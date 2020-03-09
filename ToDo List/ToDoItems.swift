//
//  ToDoItems.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 3/8/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import Foundation
import UserNotifications
class ToDoItems {
    var itemsArray: [ToDoItem] = []
  
    func saveData() {
        //going through the apps FileManager and using a URL
        //gives access to all the stuff on the file system
        //.userDomainMask is where the personal data is saved
        //by saying .first! you are getting the first element of the urls array
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //to use again, the only thing you need to do is change "todos"
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        //try? throws, meaning that if the method has an error, it will return nil
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            //.noFileProtection allows file to overwrite any existing file
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data 😡 \(error.localizedDescription)")
        }
        setNotifications()
        //put this wherever data is changed
    }
    
    func loadData(completed: @escaping ()->() ){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                     //to use again, the only thing you need to do is change "todos"
                     let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")

               guard let data = try? Data(contentsOf: documentURL) else {
                   return
               }
               let jsonDecoder = JSONDecoder()
               do {
                   itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
                  
               } catch {
                   print("ERROR: Could not load data 😡 \(error.localizedDescription)")
               }
        completed()
    }
    
    func setNotifications() {
           guard itemsArray.count > 0 else {
               return
           }
           //remove all notifications
           UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
           
           //and let's create them with updated data that we JUST saved
           for index in 0..<itemsArray.count {
               if itemsArray[index].reminderSet {
                   let toDoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
               }
           }
       }
}
