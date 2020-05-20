//
//  ToDoesTableViewController.swift
//  ToDoes
//
//  Created by Ellen Zhang on 19/05/20.
//  Copyright © 2020 Ellen Zhang. All rights reserved.
//

import UIKit

class ToDoesTableViewController: UITableViewController {
    
//    var toDoesArray = ["shopping", "laundry", "assist math"]
//    let userDefaults = UserDefaults.standard
    
    var toDoesArray = [ToDoItemModel]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let items = self.userDefaults.array(forKey: "ToDoListArray") as? [String]{
//            toDoesArray = items
//        }
//        let newItem1 = ToDoItemModel()
//        newItem1.title = "Shopping"
//        toDoesArray.append(newItem1)
//
//        let newItem2 = ToDoItemModel()
//        newItem2.title = "Laundry"
//        newItem2.done = true
//        toDoesArray.append(newItem2)
//
//        let newItem3 = ToDoItemModel()
//        newItem3.title = "Asist Math"
//        toDoesArray.append(newItem3)
        
        
        loadItems()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

//        cell.textLabel?.text = toDoesArray[indexPath.row]
        
        cell.textLabel?.text = toDoesArray[indexPath.row].title
        
        cell.accessoryType = toDoesArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        toDoesArray[indexPath.row].done = !toDoesArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.reloadData()
        
//        print(toDoesArray[indexPath.row])
    }

    @IBAction func addTodoItem(_ sender: Any) {
        
        var newItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            
//            self.toDoesArray.append(newItemTextField.text ?? "new item")
//
//            self.userDefaults.set(self.toDoesArray, forKey: "ToDoListArray")

            let newItem = ToDoItemModel()
            if newItemTextField.text != ""{
                newItem.title = newItemTextField.text!
                self.toDoesArray.append(newItem)
            }
            
            self.saveItems()
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
            newItemTextField = alertTextfield
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                toDoesArray = try decoder.decode([ToDoItemModel].self, from: data)
            }catch{
                print("error decoding items from plist \(error)")
            }
        }
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(toDoesArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error to encode data \(error)")
        }
    }
}
