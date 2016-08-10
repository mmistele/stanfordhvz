//
//  MessageTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: FirebaseTableViewController {
    
    var chatId: String?
    
    private struct Storyboard {
        static let MessageCellIdentifier = "Message"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FilteredFirebaseTableViewDataSource(query: getQuery(), prototypeReuseIdentifier: Storyboard.MessageCellIdentifier, tableView: tableView, delegate: self, populateCellBlock: { (cell, snapshot) in
            
            let messageData = snapshot.value as! [String : AnyObject]
            let messageCell = cell as! MessageTableViewCell
            
            messageCell.textLabel?.text = messageData["message"] as? String
            messageCell.messageId = snapshot.key
        })
    }
    
    override func getQuery() -> FIRDatabaseQuery {
        if chatId != nil {
            return ref.child("messages").child(chatId!)
        } else {
            return ref.child("gibberish")
        }
    }
    
}
