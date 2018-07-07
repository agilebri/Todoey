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

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        readToDoList()
        
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

            saveToDoList()
            
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

            self.saveToDoList()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextEntered = alertTextField
            print(alertTextField)
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    func readToDoList() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            }
            catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    func saveToDoList() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
}

