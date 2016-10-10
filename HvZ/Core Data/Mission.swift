//
//  Mission.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData


class Mission {

    var firebaseId: String
    
    var title: String = "Untitled"
    var descriptionText: String = ""
    var publishedToHumans: Bool = false
    var publishedToZombies: Bool = false
    
    var boundary: NSObject?
    var endTime: NSDate?
    var startTime: NSDate?
    var regionLatitude: NSNumber?
    var regionLongitude: NSNumber?
    var regionRadius: NSNumber?
    var waypoints: NSSet?
    var participants: NSSet?
    
    // These strings should probably come from a remote config
    struct FIRKeys {
        static let Title = "title"
        static let Description = "description"
        static let PublishedToHumans = "publishedToHumans"
        static let PublishedToZombies = "publishedToZombies"
    }
    
    init(uid: String) {
        firebaseId = uid
    }
    
    init(uid: String, dict: [String: AnyObject]) {
        firebaseId = uid
        
        if let title = dict[FIRKeys.Title] as? String {
            self.title = title
        }
        if let description = dict[FIRKeys.Description] as? String {
            self.descriptionText = description
        }
        if let publishedToHumans = dict[FIRKeys.PublishedToHumans] as? Bool {
            self.publishedToHumans = publishedToHumans
        }
        if let publishedToZombies = dict[FIRKeys.PublishedToZombies] as? Bool {
            self.publishedToZombies = publishedToZombies
        }
    }

}
