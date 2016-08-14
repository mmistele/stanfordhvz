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
    
    var title: String
    var description: String
    var publishedToHumans: Bool
    var publishedToZombies: Bool
    
    var boundary: NSObject?
    var details: String?
    var endTime: NSDate?
    var startTime: NSDate?
    var regionLatitude: NSNumber?
    var regionLongitude: NSNumber?
    var regionRadius: NSNumber?
    var waypoints: NSSet?
    var participants: NSSet?
    
    init(id: String) {
        firebaseId = id
        title = "Untitled"
        publishedToHumans = false
        publishedToZombies = false
        description = ""
    }
}
