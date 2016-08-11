//
//  LoginViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: KeyboardAdaptiveViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var SUNetIDField: UITextField! {
        didSet {
            SUNetIDField.delegate = self
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
            incorrectLoginLabel.text = ""
        }
    }
    
    private struct Storyboard {
        static let LogInSegueIdentifier = "Log In"
    }
    
    private var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    private var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAdaptationFromCenteredY(forView: fieldsStackView)
        subscribeToKeyboardAnimations()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        googleSignInButton.style = .Wide
        googleSignInButton.colorScheme = .Dark
    }
    
    
    // MARK: Google Sign in
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // STop animating activity indicator
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let userId = user.userID
        let fullName = user.profile.name
        let firstName = user.profile.givenName
        let lastName = user.profile.familyName
        let email = user.profile.email
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if user != nil {
                let ref = FIRDatabase.database().reference()
                ref.child("users").child(user!.uid).child("firstName").setValue(firstName)
                // Segue to either signup screen or main screen
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    // MARK: SUNet Sign in
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordField && SUNetIDField.text != nil && passwordField.text != nil {
            attemptLogin(SUNetIDField.text!, password: passwordField.text!)
        }
        return true
    }
    
    @IBAction func logInPressed(sender: UIButton) {
        if SUNetIDField.text == nil || passwordField.text == nil {
            incorrectLoginLabel.text = "Please fill in both fields."
        } else {
            attemptLogin(SUNetIDField.text!, password: passwordField.text!)
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
    
    private func attemptLogin(SUNetID: String, password: String) -> Void {
        let email = SUNetID + "@stanford.edu"
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                // There was an error - handle it!
                print(error?.localizedDescription)
                self.incorrectLoginLabel.text = "Incorrect login, try again."
            }
            else if user != nil {
                self.performSegueWithIdentifier(Storyboard.LogInSegueIdentifier, sender: self)
                return
            }
            
        })
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.LogInSegueIdentifier {
            navigationController?.removeFromParentViewController()
        }
    }
}
