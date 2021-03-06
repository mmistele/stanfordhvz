//
//  Player.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import Firebase

class Player {

    var uid: String!

    var badges: NSObject = []
    var chats: [Conversation] = []
    var clan: Clan?
    var coordinates: CLLocationCoordinate2D?
    var firstName: String?
    var isModerator: Bool = false
    var isOZ: Bool = false
    var lastName: String?
    var phoneNumber: String?
    var tagCount: Int = 0
    var tags: [Tag] = []
    var team: Team = Team.Humans
    
    var fullName: String {
        get {
            var names = [String]()
            if firstName != nil {
                names.append(firstName!)
            }
            if lastName != nil {
                names.append(lastName!)
            }
            return names.joinWithSeparator(" ")
        }
    }

    var image: NSData? = DummyStore.SampleProfileImages?[0]
    
    /**
     * Looks up the uid in the Firebase database and calls the given completion
       on the player if found - otherwise, nil.
     */
    class func playerWithUniqueId(uid: String, completion: (player: Player?) -> Void) {
        let userRef = FIRDatabase.database().reference().child("users").child(uid)
        userRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if snapshot.value != nil && !(snapshot.value is NSNull) {
                let dict = snapshot.value as! [String: AnyObject]
                let player = Player(uid: uid, dict: dict)
                completion(player: player)
            } else {
                completion(player: nil)
            }
        })
    }
    
    convenience init(snapshot: FIRDataSnapshot) {
        let uid = snapshot.key
        let dict = snapshot.value as! [String : AnyObject]
        self.init(uid: uid, dict: dict)
    }
    
    init(uid: String, dict: [String: AnyObject]) {
        self.uid = uid
        
        if let badges = dict["badges"] as? NSObject {
            self.badges = badges
        }
        if let chats = dict["chats"] as? [Conversation] {
            self.chats = chats
        }
        if let clan = dict["clan"] as? Clan {
            self.clan = clan
        }
        if let coordinates = dict["coordinates"] as? CLLocationCoordinate2D {
            self.coordinates = coordinates
        }
        if let firstName = dict["firstName"] as? String {
            self.firstName = firstName
        }
        if let isModerator = dict["isModerator"] as? Bool {
            self.isModerator = isModerator
        }
        if let isOZ = dict["isOZ"] as? Bool {
            self.isOZ = isOZ
        }
        if let lastName = dict["lastName"] as? String {
            self.lastName = lastName
        }
        if let phoneNumber = dict["phoneNumber"] as? String {
            self.phoneNumber = phoneNumber
        }
        if let tagCount = dict["tagCount"] as? Int {
            self.tagCount = tagCount
        }
        if let tags = dict["tags"] as? [Tag] {
            self.tags = tags
        }
        if let team = dict["team"] as? Team {
            self.team = team
        }
    }

}
