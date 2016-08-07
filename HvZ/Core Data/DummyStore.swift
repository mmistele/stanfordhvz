//
//  PreloadingData.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData
import CoreImage
import CoreGraphics
import UIKit

class DummyStore {
    static func preloadData(inManagedObjectContext context: NSManagedObjectContext) {
        /*
        
        if let player = Player.playerWithUniqueId("mod1") {
            player.firstName = "Mike"
            player.lastName = "Moderator"
            player.cellNumber = "3059159192"
            player.password = "password"
            player.image = SampleProfileImages![0]
            player.isModerator = true
            player.isOZ = false
            player.latitude = 37.423987
            player.longitude = -122.170908
            player.clan = Clan.clanNamed("Mod Squad", inManagedObjectContext: context)
            player.badges = NSArray(array: [])
            
            player.teamName = "Moderators"
            player.team = Team.teamNamed(player.teamName!, inManagedObjectContext: context)
            
            // Fake login
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.currentUser = player
        }
        
        if let player = Player.playerWithUniqueId("oz1") {
            player.firstName = "Michael"
            player.lastName = "Hang"
            player.cellNumber = "1234567899"
            player.password = "password"
            player.image = SampleProfileImages![1]
            player.isModerator = false
            player.isOZ = true
            player.latitude = 37.424987
            player.longitude = -122.171908
            player.clan = Clan.clanNamed("Mike's Zombies", inManagedObjectContext: context)
            player.badges = NSArray(array: ["OZ"])
            
            player.teamName = Team.ZombieTeamName
            player.team = Team.teamNamed(player.teamName!, inManagedObjectContext: context)
        }
        
        if let player = Player.playerWithUniqueId("oz2", inContext: context) {
            player.firstName = "Tudor"
            player.lastName = "Sandu"
            player.cellNumber = "1234567890"
            player.password = "password"
            player.image = SampleProfileImages![2]
            player.isModerator = false
            player.isOZ = false
            player.latitude = 37.424001
            player.longitude = -122.171001
            player.clan = nil // TEST
            player.badges = NSArray(array: [])
            
            player.teamName = Team.ZombieTeamName
            player.team = Team.teamNamed(player.teamName!, inManagedObjectContext: context)
        }
        
        if let player = Player.playerWithUniqueId("p1", inContext: context) {
            player.firstName = "Eli"
            player.lastName = "Wu"
            player.cellNumber = "1234567891"
            player.password = "password"
            player.image = SampleProfileImages![5]
            player.isModerator = false
            player.isOZ = false
            player.latitude = 37.425231
            player.longitude = -122.172001
            player.clan = Clan.clanNamed("Doominators", inManagedObjectContext: context)
            player.badges = NSArray(array: [])
            
            player.teamName = Team.HumanTeamName
            player.team = Team.teamNamed(player.teamName!, inManagedObjectContext: context)
        }
       
        if let player = Player.playerWithUniqueId("p2", inContext: context) {
            player.firstName = "Janet"
            player.lastName = "Coleman Belin"
            player.cellNumber = "1234567892"
            player.password = "password"
            player.image = SampleProfileImages![6]
            player.isModerator = false
            player.isOZ = false
            player.latitude = 37.422231
            player.longitude = -122.173001
            player.clan = Clan.clanNamed("Doominators", inManagedObjectContext: context)
            player.badges = NSArray(array: [])
            
            player.teamName = Team.HumanTeamName
            player.team = Team.teamNamed(player.teamName!, inManagedObjectContext: context)
        }
 */
        
    }
    
    static var SampleProfileImages: [NSData]? {
        get {
            return sliceImageIntoPNGs(
                named: AssetFilenames.ProfileIcons,
                rows: 4, columns: 4)
        }
    }
    
    private struct AssetFilenames {
        static let ProfileIcons = "zombieIcons"
    }
    
    // Uses CoreGraphics to slice up an image from disk and return an array of PNG data
    static func sliceImageIntoPNGs(named name: String, rows: Int, columns: Int) -> [NSData]? {
        if let uiImage = UIImage(named: name) {
            if let image = uiImage.CGImage {
                let sliceWidth = CGImageGetWidth(image) / columns
                let sliceHeight = CGImageGetHeight(image) / rows
                
                var slices = [NSData]()
                
                for r in 0...rows {
                    for c in 0...columns {
                        let sliceRect = CGRect(
                            x: c * sliceWidth,
                            y: r * sliceHeight,
                            width: sliceWidth,
                            height: sliceHeight)
                        let sliceImage = CGImageCreateWithImageInRect(image, sliceRect)
                        let sliceUIImage = UIImage(CGImage: sliceImage!)
                        if let sliceData = UIImagePNGRepresentation(sliceUIImage) {
                            slices.append(sliceData)
                        }
                    }
                }
                return slices
            }
        }
        return nil
        
    }
}