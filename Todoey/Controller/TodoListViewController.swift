//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var itemArray : Results<Item>?
    
    @IBOutlet var uiTableView : UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tableView.rowHeight = 80
       self.tableView.separatorStyle = .none
        
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let colorHex = selectedCategory?.color{
            title = selectedCategory?.name
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation Controller does not exist")
            }
            print(colorHex)
            if let navBarColor = UIColor(hexString: colorHex){
                
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                searchBar.barTintColor = navBarColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :
                ContrastColorOf(navBarColor, returnFlat: true)]
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row]{
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
                CGFloat(indexPath.row)/CGFloat(itemArray!.count)
                ){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }else{
                cell.backgroundColor = UIColor(hexString: "007AFF")
            }
            
            
            cell.textLabel?.text = item.name
            
            cell.accessoryType =  item.isChecked  ? .checkmark : .none
            
            
        }else{
            cell.textLabel?.text = "No text added"
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write{
                    item.isChecked = !item.isChecked
                }
            }catch{
                 print("error saving isChecked status : \(error) ")
            }
            tableView.reloadData()
            
        }else{
            print("error saving isChecked status ")
        }
        
        //deleteItem(index: indexPath.row)
        
        //save(item: Item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            do{
                
                try self.realm.write{
                    if let currentCategory = self.selectedCategory{
                        let newItem = Item()
                        newItem.name = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
            }catch{
                print("Error savinf item : \(error)")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter detail"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func loadItems()  {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
        
    }
    func deleteItem(item : Item)  {
        do{
            try realm.write{
                realm.delete(item)
            }
        }catch{
            print("error Deleting")
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row]{
            
            do{
                try realm.write{
                    item.isChecked = !item.isChecked
                }
            }catch{
                print("error saving status : \(error)")
            }
            
        }
    }
}


//MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter( "name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}



