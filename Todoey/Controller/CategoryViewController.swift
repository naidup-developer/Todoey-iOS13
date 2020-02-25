//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Appala Naidu on 25/02/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController : UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    @IBAction func onClickAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            
            self.saveCategory()
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
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoICategoryCell", for: indexPath)
        
        cell.textLabel?.text = category.name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    //MARK: - Data manipulation Methods
    
    func saveCategory() {
        do{
            try context.save()
        }catch{
            print("error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory()  {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        }catch{
            print("error loading category: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Prepare Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory =  categories[indexPath.row]
        }
    }
}
