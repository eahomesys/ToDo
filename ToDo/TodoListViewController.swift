//
//  ViewController.swift
//  ToDo
//
//  Created by Eric Anderson on 6/15/18.
//  Copyright © 2018 Eric Anderson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  //this is to store small bits of data.
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // This reads from the pList and populates itemArray
    if let items = defaults.array(forKey: "TodoListArray") as? [String] {
      itemArray = items
    }
  }

  //MARK - Tableview Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //Mark - Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      //what will happen when the user clicks the Add Item button on our UIAlert
      self.itemArray.append(textField.text!)
      // Save new item to the pList
      self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Enter new item"
      textField = alertTextField
    }
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  

}

