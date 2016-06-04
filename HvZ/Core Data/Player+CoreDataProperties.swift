//
//  Player+CoreDataProperties.swift
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

extension Player {

    @NSManaged var cellNumber: NSNumber?
    @NSManaged var firstName: String?
    @NSManaged var image: NSData?
    @NSManaged var isModerator: NSNumber?
    @NSManaged var lastName: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var password: String?
    @NSManaged var tagCount: NSNumber?
    @NSManaged var taggedAt: NSDate?
    @NSManaged var unique: String?
    @NSManaged var badges: NSSet?
    @NSManaged var clan: NSManagedObject?
    @NSManaged var conversations: NSManagedObject?
    @NSManaged var messagesSent: NSSet?
    @NSManaged var originalTag: NSManagedObject?
    @NSManaged var tags: NSManagedObject?
    @NSManaged var team: NSManagedObject?
    @NSManaged var missionsAttempted: NSSet?

}
