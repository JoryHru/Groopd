//
//  ViewController.swift
//  Groopd
//
//  Created by Edward Hru on 1/15/19.
//  Copyright © 2019 Edward Hru. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import ContactsUI

class GroopdListViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
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
        
        displayMessageView()
        
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
    //MARK: Messages Delegate Method
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue:
            print("Message Cancelled")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message Failed")
            controller.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message Sent")
            controller.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    //MARK: Messages Methods
    func displayMessageView() {
        
        var contactsArray = [AddContact]()
        let request = NSFetchRequest<AddContact>(entityName: "AddContact")
        
        var recipients = [String]()
        
        do {
            contactsArray = try context.fetch(request)
            
            if contactsArray.count > 0 {
                let numberOfContacts = contactsArray.count - 1
                for i in 0...numberOfContacts {
                    let match = contactsArray[i]
                    let recipientNumbers = match.value(forKey: "recipientsNumber") as! String
                    
                    print(recipientNumbers)
                    
                    recipients.append(recipientNumbers)
                }
            
        }
        } catch {
            print(error)
        }
        
        let messagesVC = MFMessageComposeViewController()
        messagesVC.messageComposeDelegate = self
        //configure view fields
        messagesVC.recipients = recipients
        messagesVC.body = message
        
        //present the view modally
        if MFMessageComposeViewController.canSendText() {
            self.present(messagesVC, animated: true, completion: nil)
        } else {
            print("Message cannot be sent")
            
        }
    }
    
    @IBAction func goToContacts(_ sender: UIButton) {
        
        
    }

}

