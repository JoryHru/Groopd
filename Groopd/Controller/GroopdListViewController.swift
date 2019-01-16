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

class GroopdListViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    var groopdsListArray = [NewGroopd]()
    
    var recipients: [String] = ["1234567890"]
    
    var message: String = "Message."
    
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
        
        displayMessageView()
        
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

}

