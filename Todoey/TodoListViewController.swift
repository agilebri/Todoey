//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Barr on 7/5/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["First Item", "Second Item", "Third Item"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.reloadData()
        
    }
    
    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        print("Current row text = \(itemArray[indexPath.row])")

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
            else {
                cell.accessoryType = .checkmark
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

