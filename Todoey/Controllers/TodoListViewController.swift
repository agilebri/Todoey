//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Barr on 7/5/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let defaults = UserDefaults.standard
    
    // let's just keep the checking of to do items function to keep items on the list for now
    let deleteOnCheck = false

    var allToDoItems : Results<ToDoItem>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            
            self.title = selectedCategory?.name
            
            readToDoList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = allToDoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.toDoItemText
        
            // Ternary operator
            cell.accessoryType = item.toDoItemChecked ? .checkmark : .none
        
            print("Current row text = \(allToDoItems![indexPath.row])")
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {

            if let item = allToDoItems?[indexPath.row] {
                do {
                    try realm.write {
                        // decide if we are deleting the To Do item when checked, or just leaving it checked
                        if deleteOnCheck {
                            realm.delete(item)
                        }
                        else {
                            item.toDoItemChecked = !item.toDoItemChecked
                        }
                    }
                }
                catch {
                    print("Error deleting or updating item, error = \(error)")
                }
            }
          
            tableView.reloadData()
            
            // turn off highlight at toggled row for better UX
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextEntered = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
 
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = ToDoItem()
                        newItem.toDoItemText = alertTextEntered.text!
                        currentCategory.toDoItems.append(newItem)
                        // NOTE: toDoItemDateCreated will get today's date/time by default

                        self.realm.add(newItem)
                    }
                }
                catch {
                    print("Error saving toDoItem \(error)")
                }
            }

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

    func readToDoList() {

        allToDoItems = selectedCategory?.toDoItems.sorted(byKeyPath: "toDoItemDateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        allToDoItems = allToDoItems?.filter("toDoItemText CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "toDoItemDateCreated", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            readToDoList()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
