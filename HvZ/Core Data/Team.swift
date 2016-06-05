//
//  Team.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData

class Team: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    class func teamNamed(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Team?
    {
        let request = NSFetchRequest(entityName: "Team")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let team = (try? context.executeFetchRequest(request))?.first as? Team {
            return team
        } else if let team = NSEntityDescription.insertNewObjectForEntityForName("Team", inManagedObjectContext: context) as? Team {
            team.name = name
            return team
        }
        
        return nil
    }
    
    static let ZombieTeamName = "Zombies"
    static let HumanTeamName = "Humans"
    
}
