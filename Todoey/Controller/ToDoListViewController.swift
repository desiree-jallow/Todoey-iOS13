//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        print(dataFilePath)
       
        // Do any additional setup after loading the view
        
        loadItems()
        
    }

    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] (alertAction) in
            
        
            let newItem = Item(context: context)
            newItem.title = textField.text!
            newItem.done = false
            itemArray.append(newItem)
            
            saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
       
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
       
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource Methods
extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
           let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        
           // Configure the cell’s contents.
        cell.textLabel!.text = item.title
               
           return cell
    }
}
//MARK: - UITableViewDelegate Methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done.toggle()
        
//        context.delete(itemArray[indexPath.row])
//
//        itemArray.remove(at: indexPath.row)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
//MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

