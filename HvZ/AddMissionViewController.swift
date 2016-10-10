//
//  EditMissionViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/13/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class AddMissionViewController: KeyboardAdaptiveViewController, UITextViewDelegate {
    
    // MARK: Variables and Constants
    
    var mission: Mission?
    
    private struct Storyboard {
        static let CancelSegueIdentifier = "Cancel"
        static let SaveSegueIdentifier = "Save"
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
        }
    }
    
    @IBOutlet weak var publishToHumansSwitch: UISwitch!
    @IBOutlet weak var publishToZombiesSwitch: UISwitch!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    // MARK: Text Field and Text View Events
    
    @IBAction func titleChanged(sender: UITextField) {
        if let title = titleField.text where !title.isEmpty {
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SaveSegueIdentifier {
            let missionRef = FIRDatabase.database().reference().child("missions").childByAutoId()
            let missionId = missionRef.key
            mission = Mission(uid: missionId)
            mission?.title = titleField.text!
            mission?.descriptionText = descriptionTextView.text
            mission?.publishedToHumans = publishToHumansSwitch.on
            mission?.publishedToHumans = publishToZombiesSwitch.on

        }
    }
    
}
