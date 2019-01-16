//
//  ViewController.swift
//  Groopd
//
//  Created by Edward Hru on 1/15/19.
//  Copyright © 2019 Edward Hru. All rights reserved.
//

import UIKit
import CoreData

class GroopdListViewController: UITableViewController {
    
    var groopdsListArray = [NewGroopd]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadGroopds()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groopdsListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroopdCell", for: indexPath)
        
        let item = groopdsListArray[indexPath.row]
        
        cell.textLabel?.text = item.groopdName
        
        return cell
    }
    
    //MARK: Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToMessages", sender: self)
        
    }
    
    //MARK: Add Button
    @IBAction func addNewGroopdButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Groopd", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Groopd", style: .default) { (action) in
            //What happens when user clicks Add Groopd button on the alert
            
            let newItem = NewGroopd(context: self.context)
            newItem.groopdName = textField.text!
            //******newItem.parentCategory = self.selectedCategory
            
            self.groopdsListArray.append(newItem)
            
            self.saveGroopds()
            
            self.performSegue(withIdentifier: "GoToContactsList", sender: self)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Groopd Title"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Save/Load Methods (needed when using core data)
    func saveGroopds() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadGroopds() {
        
        let request: NSFetchRequest<NewGroopd> = NewGroopd.fetchRequest()
        
        do {
            groopdsListArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    

}

