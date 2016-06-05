//
//  Player.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData


class Player: NSManagedObject {

    class func playerWithUniqueId(
        unique: String,
        inContext context: NSManagedObjectContext) -> Player? {
        
        let request = NSFetchRequest(entityName: "Player")
        request.predicate = NSPredicate(format: "unique = %@", unique)
        
        if let player = (try? context.executeFetchRequest(request))?.first as? Player {
            return player
        }
        else if let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: context) as? Player {
            player.unique = unique
            return player
        }
        
        return nil
    }

}
