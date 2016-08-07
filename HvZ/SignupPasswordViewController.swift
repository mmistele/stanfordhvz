//
//  SignupPasswordViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Darwin
import CoreData

class SignupPasswordViewController: KeyboardAdaptiveViewController, UITextFieldDelegate {

    private var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    private var appDelegate: AppDelegate? = (UIApplication.sharedApplication().delegate as? AppDelegate)
    
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    @IBOutlet weak var fieldStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAdaptation(forView: fieldStackView)
        subscribeToKeyboardAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation

    // Only one segue, and that's the one that makes the new user!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navcon = self.navigationController as? SignupNavigationController {
            navcon.newUserPassword = passwordField.text
        }
    }
}
