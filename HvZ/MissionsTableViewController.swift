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
    
    @IBAction func createMissionTapped(sender: UIBarButtonItem) {
        let newMissionRef = ref.child("missions").childByAutoId()
        newMissionId = newMissionRef.key
        performSegueWithIdentifier(Storyboard.CreateMissionSegueIdentifier, sender: nil)
    }
    
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
        static let Published = "published"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FilteredFirebaseTableViewDataSource(query: getQuery(), sectionNameKey: nil, prototypeReuseIdentifier: Storyboard.MissionCellIdentifier, tableView: tableView, delegate: self, populateCellBlock: { (cell, snapshot) in
            
            let missionDict = snapshot.value as! [String : AnyObject]
            cell.textLabel?.text = missionDict[FIRKeys.Title] as? String
            if let published = missionDict[FIRKeys.Published] as? Bool where !published {
                cell.detailTextLabel?.text = Storyboard.UnpublishedText
            } else {
                cell.detailTextLabel?.text = nil
            }
        })
        
        dataSource?.filterUpdated()
    }
    
    // MARK: - FilteredFirebaseTableViewDataSourceDelegate
    
    override func includeSnapshot(snapshot: FIRDataSnapshot) -> Bool {
        let missionDict = snapshot.value as! [String : AnyObject]
        if let published = missionDict[FIRKeys.Published] as? Bool {
            return published
        }
        else {
            return false
        }
    }
    
    override func getQuery() -> FIRDatabaseQuery {
        return ref.child("missions")
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
                editMissionViewController.missionId = newMissionId!
            }
        }
    }

}
