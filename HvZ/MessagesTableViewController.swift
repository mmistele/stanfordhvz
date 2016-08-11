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
    
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageTextView.text = "Message"
            messageTextView.textColor = UIColor.lightGrayColor()
            messageTextView.delegate = self
        }
    }
    
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        // Append to /messages/$chatId
        let messageRef = ref.child("messages").child(chatId!).childByAutoId()
        let timestamp = NSDate().timeIntervalSince1970
        let messageData: [String: AnyObject] = [
            "message" : messageTextView.text,
            "senderId" : FIRAuth.auth()!.currentUser!.uid,
            "timestamp" : timestamp
        ]
        messageRef.setValue(messageData)
        
        // Update /chats/$chatId
        let metadata: [String: AnyObject] = [
            "lastMessage" : messageTextView.text,
            "timestamp" : timestamp
        ]
        ref.child("chats").child(chatId!).updateChildValues(metadata)
        
        messageTextView.text = ""
        
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
            
            messageCell.message = messageData["message"] as! String
            messageCell.senderId = messageData["senderId"] as! String
            messageCell.timestamp = NSDate(timeIntervalSince1970: (messageData["timestamp"] as! Double))
            
        })
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.estimatedRowHeight = Storyboard.RowHeight //tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    func getQuery() -> FIRDatabaseQuery {
        if chatId != nil {
            return ref.child("messages").child(chatId!).queryOrderedByChild("timestamp")
        } else {
            return ref.child("bogusKeyToDisplayNothing")
        }
    }
    
    // MARK: - UITextViewDelegate Methods
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = UIColor.lightGrayColor()
            
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        UIView.animateWithDuration(0.25, animations: {
            self.sendButton.hidden = textView.text.isEmpty
            self.resizeTextViewToFitText()
        })
    }
    
    override func viewWillLayoutSubviews() {
        resizeTextViewToFitText()
    }
    
    private func resizeTextViewToFitText() {
        let sizeThatShouldFit = messageTextView.sizeThatFits(messageTextView.frame.size)
        messageTextViewHeightConstraint.constant = sizeThatShouldFit.height
    }
}
