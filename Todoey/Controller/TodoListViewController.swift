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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(itemArray.count)
        loadItems()
        
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.name = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter detail"
            textField = alertTextField
            
        }
            
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()  {
         let encoder = PropertyListEncoder()
                   do{
                       let data = try  encoder.encode(itemArray)
                       try data.write(to: dataFilePath!)
                   }catch{
                       print("Error encoding item array : \(error)")
                   }
                   
                   self.tableView.reloadData()
    }
    
    func loadItems()  {
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
    }

}

