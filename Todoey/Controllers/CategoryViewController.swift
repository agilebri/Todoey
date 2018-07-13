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

class CategoryViewController: UITableViewController {

    // Need to lazy load to ensure that didFinishLaunchingWithOptions can perform the migration
    lazy var realm:Realm = {
        return try! Realm()
    }()

    var notificationToken: NotificationToken?
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
//            // TODO: you are going to need to update array
//            readCategoryList()
//        }
        readCategoryList()
    }

    //MARK: - Tableview data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        print("Current row text = \(String(describing: categoryArray?[indexPath.row]))")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
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
 
    //MARK: - Tableview delegate methods

}
