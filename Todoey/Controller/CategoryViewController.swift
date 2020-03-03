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
import ChameleonFramework

class CategoryViewController :  SwipeTableViewController {
    
    
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        loadCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist")
        }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    @IBAction func onClickAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
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
        //let category = categories?[indexPath.row]
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
        if let category = categories?[indexPath.row]{
            
            
            guard let categoryColor = UIColor(hexString : category.color )  else {
                fatalError()
            }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            cell.textLabel?.text = category.name
            
        }else{
            cell.backgroundColor = UIColor(hexString : "007AFF")
            
            cell.textLabel?.text = "No Categeries added"
        }
        
        
            
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("error deleting while swipe : \(error)")
            }
        }
    }
    
    
}

