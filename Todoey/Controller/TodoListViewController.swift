//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    @IBOutlet var uiTableView : UITableView!
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        //print(dataFilePath!)
        
        let newItem = Item()
        newItem.name = "start bike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.name = "Move bike"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.name = "Stop Bike"
        itemArray.append(newItem2)
        
        
        print(itemArray.count)
        
            if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
                itemArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = item.name
        
        cell.accessoryType =  item.isChecked  ? .checkmark : .none
        
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.name = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter detail"
            textField = alertTextField
            
        }
            
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

