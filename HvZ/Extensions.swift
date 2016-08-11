//
//  Extensions.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/9/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

extension String {
    func containsStringCaseInsensitive(str: String) -> Bool {
        return self.lowercaseString.containsString(str.lowercaseString)
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}

extension NSDate {
    func toShortString() -> String {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let unitFlags: NSCalendarUnit = [.Weekday]
        
        let timestampComponents = calendar.components(unitFlags, fromDate: self)
        let lastMessageDay = timestampComponents.weekday
        
        let now = NSDate()
        let nowComponents = calendar.components(unitFlags, fromDate: now)
        let today = nowComponents.weekday
        
        let timeSinceMessage = now.timeIntervalSinceDate(self)
        
        let secondsInADay = NSTimeInterval(60 * 60 * 24)
        let secondsInAWeek = NSTimeInterval(Double(secondsInADay) * 7)
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        
        if lastMessageDay == today && timeSinceMessage < secondsInADay {
            // Sent today
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            return dateFormatter.stringFromDate(self)
            
        }
        else if timeSinceMessage < secondsInAWeek {
            // Sent less than a week ago
            switch lastMessageDay {
            case 0: return "Sun"
            case 1: return "Mon"
            case 2: return "Tues"
            case 3: return "Wed"
            case 4: return "Thurs"
            case 5: return "Fri"
            default: return "Sat"
            }
        }
        else {
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .NoStyle
            return dateFormatter.stringFromDate(self)
        }
    }
    
}