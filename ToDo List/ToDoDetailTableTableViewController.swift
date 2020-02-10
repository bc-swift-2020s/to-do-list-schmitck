//
//  ToDoDetailTableTableViewController.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 2/9/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit

class ToDoDetailTableTableViewController: UITableViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var toDoItem: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if toDoItem == nil {
        }
        nameField.text = toDoItem

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = nameField.text
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        //MARK:- SOFTWARE LEGO - POP AND DISMISS 
        //the presenting view controller is the new navigation controller, this will give a Boolean
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            //this means that
        navigationController?.popViewController(animated: true)
        }
    }

}
