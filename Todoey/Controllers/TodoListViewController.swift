//
//  ViewController.swift
//  Todoey
//
//  Created by Brian Barr on 7/5/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {


    
    // let's just keep the checking of to do items function to keep items on the list for now
    let deleteOnCheck = false

    var allToDoItems : Results<ToDoItem>?
    
    let realm = try! Realm()
    
    var parentCategoryColor = UIColor()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            
            self.title = selectedCategory?.name
            
            if let categoryColor = selectedCategory?.categoryBackground {
                parentCategoryColor = UIColor(hexString: categoryColor)!
            }
            else {
                parentCategoryColor = UIColor.flatGray
            }
            
            readToDoList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if let navBar = navigationController?.navigationBar {
            
            // make sure to change the nav bar back to some default color when coming back from to do item view
            navBar.barTintColor = UIColor.flatSkyBlue
            navBar.tintColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let categoryColor = selectedCategory?.categoryBackground {
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist")
            }
            
            if let navBarColor = UIColor(hexString: categoryColor) {
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                
                searchBar.isTranslucent = false
                searchBar.barTintColor = navBarColor
                searchBar.tintColor = navBarColor
            }
        }
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allToDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = allToDoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.toDoItemText
            
            if let itemColor = parentCategoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(allToDoItems!.count)) {
                cell.backgroundColor = itemColor
                cell.textLabel?.textColor = ContrastColorOf(itemColor, returnFlat: true)
                cell.tintColor = ContrastColorOf(itemColor, returnFlat: true)
            }
        
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
                        // flip the item to opposite of current checked status
                        item.toDoItemChecked = !item.toDoItemChecked

                        // decide if we are deleting the To Do item when checked, or just leaving it checked
                        if deleteOnCheck {
                            realm.delete(item)
                        }
                    }
                    tableView.reloadData()
                }
                catch {
                    print("Error deleting or updating item, error = \(error)")
                }
            }
          
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
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let toDoItem = self.allToDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(toDoItem)
                }
            }
            catch {
                print("Error deleting item, error = \(error)")
            }
        }
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
