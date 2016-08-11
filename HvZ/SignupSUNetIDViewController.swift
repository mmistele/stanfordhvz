//
//  SignupNumberViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SignupSUNetIDViewController: KeyboardAdaptiveViewController, UITextFieldDelegate {
    
    private var appDelegate: AppDelegate? = (UIApplication.sharedApplication().delegate as? AppDelegate)
    private var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    @IBOutlet weak var SUNetIDField: UITextField! {
        didSet {
            SUNetIDField.delegate = self
        }
    }
    @IBOutlet weak var fieldStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navcon = self.navigationController as? SignupNavigationController {
            
            if let SUNetID = SUNetIDField.text, password = navcon.newUserPassword {
                navcon.newUserSUNetId = SUNetID
                let email = SUNetID + "@stanford.edu"
                
                FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                    
                    if let error = error {
                        // There was an error...
                        print(error.localizedDescription)
                        
                    } else if let user = user {
                        // No errors, and we signed up a user!
                        
                        let baseRef = FIRDatabase.database().reference()
                        let newUserRef = baseRef.child("users").child(user.uid)
                        newUserRef.child("firstName").setValue(navcon.firstName)
                        newUserRef.child("lastName").setValue(navcon.lastName)
                        
                    } else {
                        // No errors but no user? Interesting...
                    }
                    
                })
                
                
            } else {
                // Say "nope bad SUNet ID"
            }
        }
        
        
    }
    private func generateUnique() -> String {
        var unique = ""
        for _ in 0...8 {
            // using http://stackoverflow.com/questions/24007129/how-does-one-generate-a-random-number-in-apples-swift-language
            unique = unique + String(arc4random_uniform(10))
        }
        return unique
    }
    
}
