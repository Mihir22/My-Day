//
//  ViewController.swift
//  My Day
//
//  Created by Mihir Mesia on 03/11/18.
//  Copyright © 2018 Mihir Mesia. All rights reserved.
//

import UIKit
import RealmSwift

class MyDayListViewController: UITableViewController{
    
    var MyDayItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        //didSet is a special keyword and between it gets triggerd as soon as selectedC sets a value
        didSet{
            loadItems()
        }
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // Do any additional setup after loading the view, typically from a nib.
       // loadItems()
        
    }
    
    //MARK-TableViewDataSource Methods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return MyDayItems?.count ?? 1
    }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDayItemCell", for: indexPath)
            
    
            if let item = MyDayItems?[indexPath.row]{
            cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
            }
            else{
                cell.textLabel?.text = "No Items Added"
            }
        return cell
            
    }
    //MARK - TableViewDelegate methods
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = MyDayItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }
            catch{
                print("Error saving done status\(error)")
            }
        }
        tableView.reloadData()
        
     
        tableView.deselectRow(at: indexPath, animated: true)
        
}
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item to MyDay", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //used for adding new items and saving the items in current category
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                        newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving new items\(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK Model Manipulation Method
    
    //with is external and request is internal parameter
    //nil used with NSPredicate to make load items usable without predicate
    func loadItems() {
       // let request: NSFetchRequest<Item> = Item.fetchRequest()
        MyDayItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
       }
}
//MARK:- Search Bar Methods
//Instead of using it in main class we created it here to make code much easy to handle and easy to understand.
extension MyDayListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        MyDayItems = MyDayItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            //Takes back to main screen when we remove our search data
            //Dispatch makes that process to run in foreground so we get rid of keyb and cursor at main screen
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


