//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Desiree on 11/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }

//MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { [self] (alertAction) in
            
        
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Datasource Methods
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories?.count ?? 1
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Fetch a cell of the appropriate type.
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            //set cell background colors
            if let color = UIColor(hexString: categories?[indexPath.row].color ?? "4891FE") {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
               // Configure the cell’s contents.
            cell.textLabel!.text = categories?[indexPath.row].name ?? "No Categories added yet"
            
        
               return cell
        }
    
    //MARK: - Data Manipulation Methods
    //save data and load data
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    func save(category: Category) {
       
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    
    }
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
            if let categoryForDeletion = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(categoryForDeletion)
                    }
                } catch  {
                    print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
}

