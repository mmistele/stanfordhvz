//
//  AddMissionViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/13/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class EditMissionViewController: KeyboardAdaptiveViewController, UITextViewDelegate {

    // MARK: Variables and Constants
    
    var mission: Mission! {
        didSet {
            titleField.text = mission.title
            descriptionTextView.text = mission.descriptionText
            publishedToHumansSwitch.on = mission.publishedToHumans
            publishedToZombiesSwitch.on = mission.publishedToZombies
        }
    }
    
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
    
    @IBOutlet weak var publishedToHumansSwitch: UISwitch!
    @IBOutlet weak var publishedToZombiesSwitch: UISwitch!

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: Actions
    
    
    @IBAction func publishSwitchFlipped(sender: UISwitch) {
        doneButton.enabled = true
    }
    
    // MARK: Text Field and Text View Events
    
    @IBAction func titleChanged(sender: UITextField) {
        doneButton.enabled = true
    }
    
    func textViewDidChange(textView: UITextView) {
        doneButton.enabled = true
    }
    
    // Do we want to autosave anything, like the title or description text when we end editing them?
    
    // MARK: - Navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == Storyboard.SaveSegueIdentifier {
                mission.title = titleField.text!
                mission.descriptionText = descriptionTextView.text
                mission.publishedToHumans = publishedToHumansSwitch.on
                mission.publishedToZombies = publishedToZombiesSwitch.on
            }
    }
    
}
