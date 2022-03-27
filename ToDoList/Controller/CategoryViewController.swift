//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Dario Mintzer on 21/03/2022.
//

import UIKit
import RealmSwift
import Hue

class CategoryViewController: SwipeTableViewController {
    
    //Realm Initialization
    let realm = try! Realm()
    // collection of categories as a Result object
    var categories: Results<Category>? //Is auto-updating
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            // what will happen when use clicks the add category on the UI Alert
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(categoryForDeletion)
                })
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}


//MARK: - TableView Datasource & Delegate Methods
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    
        cell.backgroundColor = UIColor(hex: "#524A4E").alpha(CGFloat(indexPath.row + 1) / CGFloat(categories?.count ?? 1))
        
        return cell
    }
    
    //Segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}


//MARK: - Model Manipulation Methods
extension CategoryViewController {
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving content, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
   
}
//MARK: - Random Color Extension
extension CategoryViewController {
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        return randomColor
        }
}

