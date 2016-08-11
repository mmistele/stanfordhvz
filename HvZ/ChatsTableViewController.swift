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
                // The rest is populated by the ChatTableViewCell itself
            }
        })
        
        dataSource?.filterUpdated()
    }

    // MARK: - FilteredFirebaseTableViewDataSourceDelegate
    
    override func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool {
        return true
    }
    
    override func getQuery() -> FIRDatabaseQuery {
        let userId = FIRAuth.auth()!.currentUser!.uid
        return ref.child("user-chats").child(userId)
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
