//
//  MissionViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class MissionViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.text = mission.descriptionText
            title = mission.title
        }
    }
    
    lazy var ref = FIRDatabase.database().reference()
    
    // Good to also set up a Firebase listener for changes, in case the data here gets stale.
    // (Would it violate MVC to have the Mission model listen for its own changes in Firebase?)
    var mission: Mission! /* {
        didSet {
            descriptionTextView.text = mission.descriptionText
            title = mission.title
        }
    } */
    
    // MARK: - Unwind Actions
    
    @IBAction func doneEditingMission(segue: UIStoryboardSegue) {
        
        if let editMissionViewController = segue.sourceViewController.contentViewController as? EditMissionViewController {
            if let editedMission = editMissionViewController.mission {
                mission = editedMission
                
                let missionUpdateValues: [String: AnyObject] = [
                    Mission.FIRKeys.Title : mission.title,
                    Mission.FIRKeys.PublishedToHumans : mission.publishedToHumans,
                    Mission.FIRKeys.PublishedToZombies : mission.publishedToZombies,
                    Mission.FIRKeys.Description : mission.descriptionText
                ]
                
                ref.child("missions").child(mission.firebaseId).updateChildValues(missionUpdateValues)
            }
        }
    }
    
    @IBAction func cancelEditingMission(segue: UIStoryboardSegue) {
        // Do nothing
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
