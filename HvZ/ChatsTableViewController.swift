//
//  ConversationsTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class ChatsTableViewController: FirebaseTableViewController {

    private struct Storyboard {
        static let ChatCellIdentifier = "Chat"
        static let DetailSegueIdentifier = "Show Chat"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = FilteredFirebaseTableViewDataSource(query: getQuery(), sectionNameKey: nil, prototypeReuseIdentifier: Storyboard.ChatCellIdentifier, tableView: tableView, delegate: self, populateCellBlock: { (cell, snapshot) in
            
            if let chatCell = cell as? ChatTableViewCell {
                
                chatCell.chatId = snapshot.key
                let chatData = snapshot.value as! [String : AnyObject]
                
                let title = chatData["title"] as? String ?? "Unknown"
                let lastMessage = chatData["lastMessage"] as? String
                
                chatCell.titleLabel.text = title
                chatCell.lastMessageLabel.text = lastMessage
                
                if let secondsSince1970 = chatData["timestamp"] as? Double {
                    let timestamp = NSDate(timeIntervalSince1970: secondsSince1970)
                    chatCell.lastMessageTimestamp = timestamp
                }
            }
        })
        
        dataSource?.filterUpdated()
    }

    // MARK: - FilteredFirebaseTableViewDataSourceDelegate
    
    override func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool {
        return true
    }
    
    override func getQuery() -> FIRDatabaseQuery {
        return ref.child("chats")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.DetailSegueIdentifier {
            if let messagesVC = segue.destinationViewController.contentViewController as? MessagesTableViewController, chatCell = sender as? ChatTableViewCell {
                messagesVC.chatId = chatCell.chatId
            }
        }
        
    }

}
