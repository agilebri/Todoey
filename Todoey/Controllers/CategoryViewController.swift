//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Brian Barr on 7/9/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    // Need to lazy load to ensure that didFinishLaunchingWithOptions can perform the migration
    lazy var realm:Realm = {
        return try! Realm()
    }()

    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readCategoryList()
    }

    //MARK: - Tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor(hexString: (categoryArray?[indexPath.row].categoryBackground)!)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation methods
    func readCategoryList() {
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    func saveCategoryList(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextEntered = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = alertTextEntered.text!
            newCategory.categoryBackground = UIColor.randomFlat.hexValue()
            
            self.saveCategoryList(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextEntered = alertTextField
            print(alertTextField)
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            }
            catch {
                print("Error deleting category, error = \(error)")
            }
        }
    }
}

