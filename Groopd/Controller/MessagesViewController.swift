//
//  MessagesViewController.swift
//  Groopd
//
//  Created by Edward Hru on 1/22/19.
//  Copyright © 2019 Edward Hru. All rights reserved.
//

import MessageUI
import CoreData

class MessagesViewController: MFMessageComposeViewController, MFMessageComposeViewControllerDelegate {
    
    var message: String = "Message."
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactsArray = [AddContact]()
    let request = NSFetchRequest<AddContact>(entityName: "AddContact")
    
    var newRecipients = [String]()
    
    
    func fetchData() {
        do {
            contactsArray = try context.fetch(request)
            
            if contactsArray.count > 0 {
                let numberOfContacts = contactsArray.count - 1
                for i in 0...numberOfContacts {
                    let match = contactsArray[i]
                    let recipientNumbers = match.value(forKey: "recipientsNumber") as! String
                    
                    print(recipientNumbers)
                    
                    newRecipients.append(recipientNumbers)
                }
                
            }
        } catch {
            print(error)
        }
        body = "hello"
        recipients = newRecipients
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageComposeDelegate = self
        fetchData()
        
    }
    
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
            let alert = UIAlertController(title: "Message Sent", message: "", preferredStyle: .alert)
            present(alert, animated: true)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    //MARK: Messages Methods
}
