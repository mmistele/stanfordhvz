//
//  Clan.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData


class Clan: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func clanNamed(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Clan?
    {
        let request = NSFetchRequest(entityName: "Clan")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let clan = (try? context.executeFetchRequest(request))?.first as? Clan {
            return clan
        } else if let clan = NSEntityDescription.insertNewObjectForEntityForName("Clan", inManagedObjectContext: context) as? Clan {
            clan.name = name
            return clan
        }
        
        return nil
    }

}
