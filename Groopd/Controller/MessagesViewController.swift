//
//  MessagesViewController.swift
//  Groopd
//
//  Created by Edward Hru on 1/15/19.
//  Copyright © 2019 Edward Hru. All rights reserved.
//

import MessageUI

class MessagesViewController: UINavigationController, MFMessageComposeViewControllerDelegate {
    
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
    
    func showSMS() {
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services unavailable")
            let warningAlert : UIAlertController = UIAlertController()
            warningAlert.title = "Error"
            warningAlert.message = "Could Not Send SMS"
            warningAlert.transitioningDelegate = nil
        }
        
        let displayedMessageView = MFMessageComposeViewController()
        var recipients: NSArray = ["1234567890"]
        var message: NSString = "Message."
        
        displayedMessageView.messageComposeDelegate = self
        displayedMessageView.recipients = recipients as? [String]
        displayedMessageView.body = message as String
        
        self.present(displayedMessageView, animated: true, completion: nil)
        
    }
    
    
}
