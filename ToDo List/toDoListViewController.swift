//
//  ViewController.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 2/8/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//THIS IS THE SOURCE OF THE DATA

import UIKit
import UserNotifications

class toDoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var toDoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        authorizeLocalNotifications()
    }
    
    //function to request authorization so we can send notifications
    func authorizeLocalNotifications() {
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
    
    func setNotifications() {
        guard toDoItems.count > 0 else {
            return
        }
        //remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //and let's create them with updated data that we JUST saved
        for index in 0..<toDoItems.count {
            if toDoItems[index].reminderSet {
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
    
    func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
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
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
              //to use again, the only thing you need to do is change "todos"
              let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {
            return
        }
        let jsonDecoder = JSONDecoder()
        do {
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("ERROR: Could not load data 😡 \(error.localizedDescription)")
        }
    }
    
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
        let data = try? jsonEncoder.encode(toDoItems)
        do {
            //.noFileProtection allows file to overwrite any existing file
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data 😡 \(error.localizedDescription)")
        }
        //put this wherever data is changed
       setNotifications()
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            //this is where our segue is headed
        let destination = segue.destination as! ToDoDetailTableTableViewController
            //this is an OPTIONAL, but we are 100% that there is going to be a table view cell, which has a value
        let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ToDoDetailTableTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            toDoItems[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
            toDoItems.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
            saveData()
        }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
                    sender.title = "Edit"
                    addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension toDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate{
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender){
            toDoItems[selectedIndexPath.row].completed = !toDoItems[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
    }
    
    //these functions are DEMANDED by the tableView
    //predefined funciton names can be option clicked on for their descriptions
    
    //tells the data source to return the number of rows in a given section of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section is being called, returning \(toDoItems.count)")
        return toDoItems.count
    }
    //asks the data source (ToDoListViewController Code) for a cell to insert in a particular location in tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for tow was just called for indexPath.row = \(indexPath.row) which is the cell containing \(toDoItems[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self // means the view controller is going to be the delegate of the ListTableViewCell
        cell.nameLabel.text = toDoItems[indexPath.row].name
        cell.checkBoxButton.isSelected = toDoItems[indexPath.row].completed
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
}
