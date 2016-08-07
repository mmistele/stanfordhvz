//
//  Conversation+CoreDataProperties.swift
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

extension Conversation {

    @NSManaged var name: String?
    @NSManaged var clan: Clan?
    @NSManaged var messages: NSSet?
    @NSManaged var team: Team?

}
