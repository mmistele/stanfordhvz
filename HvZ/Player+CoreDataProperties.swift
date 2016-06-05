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

    @NSManaged var cellNumber: String?
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
    @NSManaged var teamName: String?
    @NSManaged var badges: NSObject?
    @NSManaged var isOZ: NSNumber?
    @NSManaged var clan: Clan?
    @NSManaged var conversations: Conversation?
    @NSManaged var messagesSent: NSSet?
    @NSManaged var originalTag: Tag?
    @NSManaged var tags: Tag?
    @NSManaged var team: Team?
    @NSManaged var missionsAttempted: NSSet?

}
