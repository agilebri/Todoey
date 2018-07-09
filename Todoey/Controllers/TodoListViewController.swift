//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Barr on 7/5/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let defaults = UserDefaults.standard

    var itemArray = [ToDoItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        // get initial ToDoItem's from store using default, empty request
        readToDoList()
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

            // use these two lines to remove item from context and then removing item from array
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
            
            saveToDoList()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextEntered = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         
            let newItem = ToDoItem(context: self.context)
            newItem.toDoItemText = alertTextEntered.text
            newItem.toDoItemChecked = false

            self.itemArray.append(newItem)

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

    func readToDoList(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func saveToDoList() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        
        request.predicate = NSPredicate(format: "toDoItemText CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "toDoItemText", ascending: true)]

        readToDoList(with: request)
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
