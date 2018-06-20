//
//  ViewController.swift
//  ToDo
//
//  Created by Eric Anderson on 6/15/18.
//  Copyright © 2018 Eric Anderson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  
  var selectedCategory : Category? {
    didSet{
      loadItems()
    }
  }
  
  // write to our own plist without limited types
  //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  //this is to store small bits of data.
  //let defaults = UserDefaults.standard
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()

    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    // This reads from the pList and populates itemArray
//    if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//      itemArray = items
//    }
  }

  //MARK: - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    
    //Ternary Operator
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
    //Updating data
    //itemArray[indexPath.row].setValue("Completed", forKey: "title")
    
    // to delete an item - must be done in this order!
//    context.delete(itemArray[indexPath.row])
//    itemArray.remove(at: indexPath.row)
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //Mark: - Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //what will happen when the user clicks the Add Item button on our UIAlert
      
      
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      
      self.itemArray.append(newItem)
      
      // Save new item to the pList
      //self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      self.saveItems()
     
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Enter new item"
      textField = alertTextField
    }
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: - Model Manipulation Methods
  
  func saveItems()  {
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
     tableView.reloadData()
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    }
  
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context, \(error)")
    }
    
    tableView.reloadData()
    
  }

  
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // set  up the search
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    //order the results
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    //go get the results
    loadItems(with: request, predicate: predicate)
    

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
