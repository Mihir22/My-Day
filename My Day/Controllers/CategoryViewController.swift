//
//  CategoryViewController.swift
//  My Day
//
//  Created by Mihir Mesia on 03/11/18.
//  Copyright © 2018 Mihir Mesia. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var Categories : Results<Category>?
    let realm = try! Realm()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

        
            }
    //MARK : Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ?? is nil coalescing which means if condition is nil then it will return value as per condition
        //Categoies? is used because of optional used at while declaring Categories
        return Categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = Categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    //MARK : TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyDayListViewController
        // used if to check nil value while performing segue
        if let indexPath = tableView.indexPathForSelectedRow{
            //selectedCategory declared in MyDayListController
            destinationVC.selectedCategory = Categories?[indexPath.row]
        }
    }
    
    
    //MARK : Data Manipulation Method
    func save(category: Category){
            
            do{
                try realm.write {
                    realm.add(category)
                }}
            catch{
                print("Error saving context\(error)")
            }
            self.tableView.reloadData()
        }
        //with is external and request is internal parameter
        func loadItems() {
            // let request: NSFetchRequest<Item> = Item.fetchRequest()
            Categories = realm.objects(Category.self)
            tableView.reloadData()
        }
    //MARK : Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item to MyDay", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
        
        let newCategory = Category()
        newCategory.name = textField.text!
        
        
            self.save(category: newCategory)
        
        
        }
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create New Item"
        textField = alertTextField
        
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
   

}

