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
        
        let mod1 = Player.playerWithUniqueId(
            "mod1",
            inContext: context,
            firstName: "Mike",
            lastName: "Moderator",
            cellNumber: "3059159192",
            password: "password",
            imageData: SampleProfileImages![0],
            isModerator: true,
            latitude: 37.423987,
            longitude: -122.170908,
            clanName: "ModSquad",
            teamName: Team.HumanTeamName,
            badges: [])
        
        let oz1 = Player.playerWithUniqueId(
            "oz1",
            inContext: context,
            firstName: "Trevor",
            lastName: "Kalkus",
            cellNumber: "1234567899",
            password: "password",
            imageData: SampleProfileImages![1],
            isModerator: false,
            latitude: 37.424987,
            longitude: -122.171908,
            clanName: "Original Zombies",
            teamName: Team.ZombieTeamName,
            badges: [])
        
        let oz2 = Player.playerWithUniqueId(
            "oz2",
            inContext: context,
            firstName: "Tudor",
            lastName: "Sandu",
            cellNumber: "1234567890",
            password: "password",
            imageData: SampleProfileImages![2],
            isModerator: false,
            latitude: 37.424001,
            longitude: -122.171001,
            clanName: nil,
            teamName: Team.ZombieTeamName,
            badges: [])
        
        let human1 = Player.playerWithUniqueId(
            "human1",
            inContext: context,
            firstName: "Eli",
            lastName: "Wu",
            cellNumber: "1234567891",
            password: "password",
            imageData: SampleProfileImages![5],
            isModerator: false,
            latitude: 37.424787,
            longitude: -122.170908,
            clanName: "Doominators",
            teamName: Team.HumanTeamName,
            badges: [])
        
        let human2 = Player.playerWithUniqueId(
            "human2",
            inContext: context,
            firstName: "Janet",
            lastName: "Coleman Belin",
            cellNumber: "1234567892",
            password: "password",
            imageData: SampleProfileImages![6],
            isModerator: false,
            latitude: 37.424887,
            longitude: -122.170808,
            clanName: "Doominators",
            teamName: Team.HumanTeamName,
            badges: [])
        
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