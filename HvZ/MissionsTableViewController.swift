//
//  MissionsTableViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class MissionsTableViewController: FirebaseTableViewController {

    @IBOutlet weak var createMissionButton: UIBarButtonItem!
    
    var newMissionId: String?
    
    private struct Storyboard {
        static let MissionCellIdentifier = "Mission"
        static let DetailSegueIdentifier = "Show Mission"
        static let CreateMissionSegueIdentifier = "Create Mission"
        static let UnpublishedText = "Draft"
        static let NewMissionControllerTitle = "New Mission"
    }
    
    // These strings should probably come from a remote config
    private struct FIRKeys {
        static let Title = "title"
        static let PublishedToHumans = "publishedToHumans"
        static let PublishedToZombies = "publishedToZombies"
        static let Description = "description"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FilteredFirebaseTableViewDataSource(query: getQuery(), sectionNameKey: nil, prototypeReuseIdentifier: Storyboard.MissionCellIdentifier, tableView: tableView, delegate: self, populateCellBlock: { (cell, snapshot) in
            
            let missionDict = snapshot.value as! [String : AnyObject]
            cell.textLabel?.text = missionDict[FIRKeys.Title] as? String
            if let publishedToHumans = missionDict[FIRKeys.PublishedToHumans] as? Bool, publishedToZombies = missionDict[FIRKeys.PublishedToZombies] as? Bool where !publishedToHumans && !publishedToZombies {
                cell.detailTextLabel?.text = Storyboard.UnpublishedText
            } else {
                cell.detailTextLabel?.text = nil
            }
        })
        
        dataSource?.filterUpdated()
    }
    
    
    // MARK: - FilteredFirebaseTableViewDataSourceDelegate
    
    override func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let user = appDelegate.currentUser {
            let missionDict = snapshot.value as! [String : AnyObject]
            if user.isModerator {
                return true
            }
            else if let publishedToHumans = missionDict[FIRKeys.PublishedToHumans] as? Bool where user.team == Team.Humans {
                return publishedToHumans
            }
            else if let publishedToZombies = missionDict[FIRKeys.PublishedToHumans] as? Bool where user.team == Team.Zombies {
                return publishedToZombies
                
            } else if let publishedToHumans = missionDict[FIRKeys.PublishedToHumans] as? Bool, publishedToZombies = missionDict[FIRKeys.PublishedToHumans] as? Bool  {
                return publishedToZombies && publishedToHumans
            }
        }
        return false
    }
    
    override func getQuery() -> FIRDatabaseQuery {
        return ref.child("missions")
    }
    
    // MARK: - Unwind Actions
    @IBAction func saveNewMission(segue: UIStoryboardSegue) {
        
        if let newMissionViewController = segue.sourceViewController.contentViewController as? AddMissionViewController {
            if let mission = newMissionViewController.mission {
                
                let missionUpdateValues: [String: AnyObject] = [
                    FIRKeys.Title : mission.title,
                    FIRKeys.PublishedToHumans : mission.publishedToHumans,
                    FIRKeys.PublishedToZombies : mission.publishedToZombies,
                    FIRKeys.Description : mission.description
                ]
                
                ref.child("missions").child(mission.firebaseId).updateChildValues(missionUpdateValues)
            }
        }
    }
    
    @IBAction func cancelNewMission(segue: UIStoryboardSegue) {
        // Do nothing special
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.DetailSegueIdentifier {
            if let missionViewController = segue.destinationViewController.contentViewController as? MissionViewController, missionCell = sender as? UITableViewCell {
                missionViewController.title = missionCell.textLabel?.text
            }
        } else if segue.identifier == Storyboard.CreateMissionSegueIdentifier {
            if let editMissionViewController = segue.destinationViewController.contentViewController as? EditMissionViewController {
                editMissionViewController.title = Storyboard.NewMissionControllerTitle
            }
        }
    }

}
