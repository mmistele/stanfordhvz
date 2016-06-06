//
//  LoginViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: KeyboardAdaptiveViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberField: UITextField! {
        didSet {
            phoneNumberField.delegate = self
        }
    }
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.delegate = self
        }
    }
    
    @IBOutlet weak var fieldsStackView: UIStackView!
    @IBOutlet weak var incorrectLoginLabel: UILabel! {
        didSet {
            incorrectLoginLabel.hidden = true
        }
    }
    
    private struct Storyboard {
        static let LogInSegueIdentifier = "Log In"
    }
    
    private var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    private var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAdaptation(forView: fieldsStackView)
        subscribeToKeyboardAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordField && phoneNumberField.text != nil && passwordField.text != nil {
            attemptLogin(phoneNumberField.text!, password: passwordField.text!)
        }
        return true
    }
    
    @IBAction func logInPressed(sender: UIButton) {
        if phoneNumberField.text == nil || passwordField.text == nil {
            incorrectLoginLabel.hidden = false
            incorrectLoginLabel.text = "Please fill in both fields."
        } else {
            attemptLogin(phoneNumberField.text!, password: passwordField.text!)
        }
        
    }
    
    // Set up in the storyboard for convenience, but we make the sender have to be programmatic (aka self)
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let loginViewController = sender as? LoginViewController {
            return loginViewController == self
        } else {
            return false
        }
    }
    
    private func attemptLogin(phoneNumber: String, password: String) -> Void {
        if let context = managedObjectContext {
            let request = NSFetchRequest(entityName: "Player")
            request.predicate = NSPredicate(format: "cellNumber = %@ AND password = %@", phoneNumber, password)
            if let user = try? context.executeFetchRequest(request).first {
                player = user! as? Player
                if player != nil {
                    (UIApplication.sharedApplication().delegate as? AppDelegate)?.currentUser = player
                    performSegueWithIdentifier(Storyboard.LogInSegueIdentifier, sender: self)
                } else {
                    incorrectLoginLabel.text = "Incorrect login, try again."
                    incorrectLoginLabel.hidden = false
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.LogInSegueIdentifier {
            navigationController?.removeFromParentViewController()
        }
    }
}
