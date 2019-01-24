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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactsArray = [AddContact]()
    
    var newRecipients = [String]()
    
    var selectedGroopd: NewGroopd? {
        didSet {
            fetchData()
        }
    }
    
    func fetchData() {
        
        let request: NSFetchRequest<AddContact> = AddContact.fetchRequest()
        let predicate = NSPredicate(format: "parentGroopd.groopdName MATCHES %@", selectedGroopd!.groopdName!)
        request.predicate = predicate
        
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
        body = ""
        recipients = newRecipients
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageComposeDelegate = self
        
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            print("Message Cancelled")
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message Failed")
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message Sent")
            let alert = UIAlertController(title: "Message Sent", message: "", preferredStyle: .alert)
            present(alert, animated: true)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: nil)
                controller.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    //MARK: Messages Methods
}
