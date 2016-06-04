//
//  Mission+CoreDataProperties.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Mission {

    @NSManaged var boundary: NSObject?
    @NSManaged var details: String?
    @NSManaged var endTime: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var title: String?
    @NSManaged var published: NSNumber?
    @NSManaged var regionLatitude: NSNumber?
    @NSManaged var regionLongitude: NSNumber?
    @NSManaged var regionRadius: NSNumber?
    @NSManaged var waypoints: NSSet?
    @NSManaged var participants: NSSet?

}
