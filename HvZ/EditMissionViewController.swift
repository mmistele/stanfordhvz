//
//  AddMissionViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/13/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class EditMissionViewController: UIViewController, UITextViewDelegate {

    // MARK: Variables and Constants
    
    var mission: Mission!
    
    lazy var missionRef: FIRDatabaseReference = FIRDatabase.database().reference().child("missions").child(self.mission.firebaseId)
    
    private var missionHandle: FIRDatabaseHandle?
    
    private struct Storyboard {
        static let CancelSegueIdentifier = "Cancel"
        static let SaveSegueIdentifier = "Save"
    }
    
    private struct FIRKeys {
        static let Title = "title"
        static let Description = "description"
        static let Published = "published"
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
        }
    }
    
    @IBOutlet weak var publishedSwitch: UISwitch!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: Actions
    
    
    @IBAction func publishSwitchFlipped(sender: UISwitch) {
        doneButton.enabled = true
    }
    
    // MARK: Text Field and Text View Events
    @IBAction func titleChanged(sender: UITextField) {
        doneButton.enabled = true
    }
    
    @IBAction func titleDidEndEditing(sender: UITextField) {
        // Do we want to autosave here?
    }
    
    func textViewDidChange(textView: UITextView) {
        doneButton.enabled = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == descriptionTextView {
            // Do we want to autosave here?
        }
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if missionHandle == nil {
            missionHandle = missionRef.observeEventType(.Value, withBlock: {[weak self] (snapshot) in
                // TODO: First check to make sure they're not in the middle of editing and being overwritten by someone else
                if let missionData = snapshot.value as? [String : AnyObject] {
                    if let title = missionData[FIRKeys.Title] as? String {
                        self?.titleField.text = title
                    }
                    if let description = missionData[FIRKeys.Description] as? String {
                        self?.descriptionTextView.text = description
                    }
                    if let isPublished = missionData[FIRKeys.Published] as? Bool {
                        self?.publishedSwitch.on = isPublished
                    }
                }
                })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if missionHandle != nil {
            missionRef.removeObserverWithHandle(missionHandle!)
            missionHandle = nil
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
