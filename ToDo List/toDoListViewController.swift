//
//  ViewController.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 2/8/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//THIS IS THE SOURCE OF THE DATA

import UIKit

class toDoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var toDoArray = ["Learn Swift", "Build Apps", "Change the World", "Take a Vacation"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            //this is where our segue is headed
        let destination = segue.destination as! ToDoDetailTableTableViewController
            //this is an OPTIONAL, but we are 100% that there is going to be a table view cell, which has a value
        let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.toDoItem = toDoArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ToDoDetailTableTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            toDoArray[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            toDoArray.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
        }
    }

extension toDoListViewController: UITableViewDelegate, UITableViewDataSource{
    //these functions are DEMANDED by the tableView
    //predefined funciton names can be option clicked on for their descriptions
    
    //tells the data source to return the number of rows in a given section of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section is being called, returning \(toDoArray.count)")
        return toDoArray.count
    }
    //asks the data source (ToDoListViewController Code) for a cell to insert in a particular location in tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for tow was just called for indexPath.row = \(indexPath.row) which is the cell containing \(toDoArray[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
    
}
