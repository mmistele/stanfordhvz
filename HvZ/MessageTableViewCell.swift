//
//  MessageTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase


// TODO: Add and remove the firebase observers when this cell loads and unloads
class MessageTableViewCell: UITableViewCell {
    
    var messageId: String!
    var senderId: String! {
        didSet {
            senderRef = FIRDatabase.database().reference().child("users").child(senderId)
            if senderObserverHandle != nil {
                senderRef.removeObserverWithHandle(senderObserverHandle!)
            }
            senderObserverHandle = senderRef.observeEventType(FIRDataEventType.Value, withBlock: { [weak self](userSnapshot) in
                if self != nil {
                    self!.sender = Player(snapshot: userSnapshot)
                }
            })
        }
    }
    
    var sender: Player! {
        didSet {
            senderLabel.text = sender.fullName
        }
    }
    var timestamp: NSDate! {
        didSet {
            timeLabel.text = timestamp.toShortString()
        }
    }
    var message: String! {
        didSet {
            messageLabel.text = message
        }
    }
    
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var senderRef: FIRDatabaseReference!
    var senderObserverHandle: FIRDatabaseHandle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // If we want chat bubbles, check out https://gist.github.com/Katafalkas/eb5e840df1ace981c359
    // with byRoundingCorners fix from http://stackoverflow.com/questions/31919867/using-uibezierpathbyroundingcorners-with-swift-2-0
    
}
