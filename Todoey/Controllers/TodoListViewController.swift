//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Barr on 7/5/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let defaults = UserDefaults.standard

    var itemArray = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = ToDoItem(toDoItemText: "Static Item 1", toDoItemChecked: false)
        itemArray.append(newItem)
        
        let newItem2 = ToDoItem(toDoItemText: "Static Item 2", toDoItemChecked: false)
        itemArray.append(newItem2)

        let newItem3 = ToDoItem(toDoItemText: "Static Item 3", toDoItemChecked: false)
        itemArray.append(newItem3)

        if let loadArray = defaults.array(forKey: "TodoListArray7") {

            itemArray = loadArray as! [ToDoItem]
            print("Loaded itemArray")

        }
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.reloadData()
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.toDoItemText
        
        // Ternary operator
        cell.accessoryType = item.toDoItemChecked ? .checkmark : .none
        
        print("Current row text = \(itemArray[indexPath.row])")

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {

            itemArray[indexPath.row].toDoItemChecked = !itemArray[indexPath.row].toDoItemChecked

            tableView.reloadData()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextEntered = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //
            let toDoItem = ToDoItem(toDoItemText: alertTextEntered.text!, toDoItemChecked: false)
            self.itemArray.append(toDoItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray7")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextEntered = alertTextField
            print(alertTextField)
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

