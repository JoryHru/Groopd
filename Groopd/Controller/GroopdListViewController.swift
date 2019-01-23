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
    
    //var recipients: [String] = ["1234567890"]
    
    var message: String = "Message."
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedCell = groopdsListArray[sourceIndexPath.row]
        groopdsListArray.remove(at: sourceIndexPath.row)
        groopdsListArray.insert(movedCell, at: destinationIndexPath.row)
        
        let newItem = NewGroopd(context: self.context)
        newItem.indexNumber = Int16(destinationIndexPath.row)
        
        saveGroopds()
        
    }
       
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context.delete(groopdsListArray[indexPath.row])
            groopdsListArray.remove(at: indexPath.row)
            saveGroopds()
        }
    }
    
    //MARK: Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let displayMessageVC = MessagesViewController()
        displayMessageVC.selectedGroopd = groopdsListArray[indexPath.row]
        present(displayMessageVC, animated: true, completion: nil)
        
    }
    
    //MARK: Add/Edit Buttons
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContactsListViewController
        
        destinationVC.selectedGroopd = groopdsListArray[groopdsListArray.count - 1]
        print(groopdsListArray.count)
    }
    
    @IBAction func editGroopdButtonPressed(_ sender: UIBarButtonItem) {
        
        self.isEditing = !self.isEditing
        
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
    
    
    @IBAction func goToContacts(_ sender: UIButton) {
        
        
    }

}

