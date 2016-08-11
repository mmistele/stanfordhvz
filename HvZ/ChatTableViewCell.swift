//
//  ChatTableViewCell.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/9/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    
    // MARK: - Helpers
    private let dateFormatter = NSDateFormatter()
    
    // MARK: - Data and Property Observers
    
    var chatId: String! {
        didSet {
            chatRef = FIRDatabase.database().reference().child("chats").child(chatId)
            if chatObserverHandle != nil {
                chatRef.removeObserverWithHandle(chatObserverHandle!)
            }
            chatObserverHandle = chatRef.observeEventType(FIRDataEventType.Value, withBlock: { [weak self] (snapshot) in
                if self != nil {
                    if let chatData = snapshot.value as? [String : AnyObject] {
                        
                        let title = chatData["title"] as? String ?? "Unknown"
                        let lastMessage = chatData["lastMessage"] as? String
                        
                        self!.titleLabel.text = title
                        self!.lastMessageLabel.text = lastMessage
                        
                        if let secondsSince1970 = chatData["timestamp"] as? Double {
                            let timestamp = NSDate(timeIntervalSince1970: secondsSince1970)
                            self!.lastMessageTimestamp = timestamp
                        }
                    }
                }
            })
        }
    }
    
    var chatRef: FIRDatabaseReference!
    var chatObserverHandle: FIRDatabaseHandle?
    
    var lastMessageTimestamp: NSDate! {
        didSet {
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
            let unitFlags: NSCalendarUnit = [.Weekday]
            
            let timestampComponents = calendar.components(unitFlags, fromDate: lastMessageTimestamp)
            let lastMessageDay = timestampComponents.weekday
            
            let now = NSDate()
            let nowComponents = calendar.components(unitFlags, fromDate: now)
            let today = nowComponents.weekday
            
            let timeSinceMessage = now.timeIntervalSinceDate(lastMessageTimestamp)
            
            let secondsInADay = NSTimeInterval(60 * 60 * 24)
            let secondsInAWeek = NSTimeInterval(Double(secondsInADay) * 7)
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
            
            
            if timeSinceMessage < 0 {
                // A little Easter egg for any database testers messing with timestamps :)
                lastMessageTimeLabel.text = "Great Scott!"
            }
            else if lastMessageDay == today && timeSinceMessage < secondsInADay {
                // Sent today
                dateFormatter.dateStyle = .NoStyle
                dateFormatter.timeStyle = .ShortStyle
                lastMessageTimeLabel.text = dateFormatter.stringFromDate(lastMessageTimestamp)
                
            }
            else if timeSinceMessage < secondsInAWeek {
                // Sent less than a week ago
                lastMessageTimeLabel.text = dayAbbreviations[lastMessageDay]
            }
            else {
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .NoStyle
                lastMessageTimeLabel.text = dateFormatter.stringFromDate(lastMessageTimestamp)
            }
        }
    }
    
    // MARK: - Event Handling
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Refactor To Elsewhere
    
    let dayAbbreviations = [
        0: "Sun",
        1: "Mon",
        2: "Tues",
        3: "Wed",
        4: "Thurs",
        5: "Fri",
        6: "Sat"
    ]
    
}
