//
//  MessageTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI

class MessagesTableViewController: KeyboardAdaptiveViewController, UITableViewDelegate, UITextViewDelegate {
    
    var chatId: String?
    
    lazy var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
        
    @IBAction func sendButtonTapped(sender: UIButton) {
        
    }
    
    var dataSource: FirebaseTableViewDataSource?

    private struct Storyboard {
        static let MessageCellIdentifier = "Message"
        static let RowHeight = CGFloat(80)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FirebaseTableViewDataSource(query: getQuery(), prototypeReuseIdentifier: Storyboard.MessageCellIdentifier, view: tableView)
        dataSource?.populateCellWithBlock({ (cell, snapshotObj) in
            let snapshot = snapshotObj as! FIRDataSnapshot
            let messageData = snapshot.value as! [String : AnyObject]
            let messageCell = cell as! MessageTableViewCell
            
            messageCell.textLabel?.text = messageData["message"] as? String
            messageCell.messageId = snapshot.key
        })
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.estimatedRowHeight = Storyboard.RowHeight //tableView.rowHeight
        tableView.rowHeight = Storyboard.RowHeight // UITableViewAutomaticDimension
        
//        setUpAdaptation(forView: adaptingStackView)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getQuery() -> FIRDatabaseQuery {
        if chatId != nil {
            return ref.child("messages").child(chatId!)
        } else {
            return ref.child("bogusKeyToDisplayNothing")
        }
    }
    
    
    
}
