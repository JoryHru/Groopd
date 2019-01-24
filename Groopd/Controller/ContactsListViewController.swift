//
//  ContactsListViewController.swift
//  Groopd
//
//  Created by Edward Hru on 1/15/19.
//  Copyright © 2019 Edward Hru. All rights reserved.
//

import UIKit
import ContactsUI
import CoreData

class ContactsListViewController: UITableViewController, CNContactPickerDelegate {

    var contactsArray = [AddContact]()
    
    var selectedGroopd: NewGroopd? {
        didSet {
            loadContacts()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath)
        
        let contact = contactsArray[indexPath.row]
        
        cell.textLabel?.text = contact.recipientsName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context.delete(contactsArray[indexPath.row])
            contactsArray.remove(at: indexPath.row)
            saveContacts()
        }
    }

    //MARK: Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: Add Contacts Button
    @IBAction func addContactsButtonPressed(_ sender: UIBarButtonItem) {
        
        let selectContactsVC = CNContactPickerViewController()
        selectContactsVC.delegate = self
        self.present(selectContactsVC, animated: true, completion: nil)
        
    }
    
    //MARK: selectContactsVC Delegate Method
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let newItem = AddContact(context: self.context)
        newItem.recipientsName = contact.givenName + " " + contact.familyName
        newItem.recipientsNumber = (contact.phoneNumbers[0].value as CNPhoneNumber).stringValue
        newItem.parentGroopd = selectedGroopd
        contactsArray.append(newItem)
        saveContacts()
    }
    //MARK: Save/Load Data Methods
    func saveContacts() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadContacts() {
        
        let request: NSFetchRequest<AddContact> = AddContact.fetchRequest()
        let predicate = NSPredicate(format: "parentGroopd.groopdName MATCHES %@", selectedGroopd!.groopdName!)
        request.predicate = predicate
        
        do {
            contactsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
        
}
