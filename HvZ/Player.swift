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
        inContext context: NSManagedObjectContext,
                  firstName: String,
                  lastName: String,
                  cellNumber: String?,
                  password: String,
                  imageData: NSData?,
                  isModerator: Bool,
                  latitude: Double,
                  longitude: Double,
                  clanName: String?,
                  teamName: String,
                  badges: [String]) -> Player? {
        
        let request = NSFetchRequest(entityName: "Player")
        request.predicate = NSPredicate(format: "unique = %@", unique)
        
        if let player = (try? context.executeFetchRequest(request))?.first as? Player {
            return player
        }
        else if let player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: context) as? Player {
            player.firstName = firstName
            player.lastName = lastName
            player.unique = unique
            player.cellNumber = cellNumber
            player.password = password
            player.image = imageData
            player.isModerator = isModerator
            player.latitude = latitude
            player.longitude = longitude
            player.teamName = teamName
            player.badges = badges
            
            player.team = Team.teamNamed(teamName, inManagedObjectContext: context)
            if clanName != nil {
                player.clan = Clan.clanNamed(clanName!, inManagedObjectContext: context)
            }
            return player
        }
        return nil
    }

}
