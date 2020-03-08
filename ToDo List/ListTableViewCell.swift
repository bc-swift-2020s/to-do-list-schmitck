//
//  ListTableViewCell.swift
//  ToDo List
//
//  Created by Cooper Schmitz on 3/7/20.
//  Copyright © 2020 Cooper Schmitz. All rights reserved.
//

import UIKit
//writing protocol

protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
}
class ListTableViewCell: UITableViewCell {
//included a variable to keep track of the delegate
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ListTableViewCellDelegate?
    
    var toDoItem: ToDoItem! {
        didSet{
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.completed
        }
    }
    
    @IBAction func checkToggle(_ sender: UIButton) {
       //self refers to this class
        // function to call delegate and call the function that it is required to do in the protocol
        delegate?.checkBoxToggle(sender: self)
    }
    
}
