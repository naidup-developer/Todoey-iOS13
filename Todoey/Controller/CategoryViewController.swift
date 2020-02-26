//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Appala Naidu on 25/02/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController : UITableViewController {
    
    
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        loadCategory()
    }
    @IBAction func onClickAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoICategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = category?.name ?? "No Categeries added"
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    
    
    
    //MARK: - Data manipulation Methods
    
    func save(category : Category) {
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory()  {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory =  categories![indexPath.row]
        }
    }
    
    func delete(index : Int)  {
        do{
            try realm.write{
                realm.delete(self.categories![index])
            }
        }catch{
            print("error Deleting")
        }
        
        tableView.reloadData()
    }
}

extension CategoryViewController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indecPath) in
            
            do{
                try self.realm.write{
                    self.realm.delete(self.categories![indexPath.row])
                }
            }catch{
                print("error Deleting")
            }
            
            tableView.reloadData()
        }
        
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}
