//
//  ViewController.swift
//  My Day
//
//  Created by Mihir Mesia on 10/10/18.
//  Copyright © 2018 Mihir Mesia. All rights reserved.
//

import UIKit

class MyDayListViewController: UITableViewController{
    
   var itemArray = [Item]()
  
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        print(dataFilePath!)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //MARK-TableViewDataSource Methods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyDayItemCell", for: indexPath)
            
    
            let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
            
    }
    //MARK - TableViewDelegate methods
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
      saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
}
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item to MyDay", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            self.saveItems()
            
          
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }
        catch{
            
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("error decoding item array\(error)")
            }
        }
    }

}
