//
//  TitleScreenViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 8/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Firebase

class TitleScreenViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    private struct Storyboard {
        static let SignInSegueIdentifier = "Sign In"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = .Standard
        signInButton.colorScheme = .Light
        
        GIDSignIn.sharedInstance().signInSilently()
    
    }
    
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
                let userRef = FIRDatabase.database().reference().child("users").child(user!.uid)
                userRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                    if snapshot.value == nil || snapshot.value is NSNull {
                        // User is new!
                        let userValues: [String: AnyObject] = [
                            "firstName": firstName,
                            "lastName": lastName,
                            "email": email
                        ]
                        userRef.updateChildValues(userValues)
                        self.loadDummyDataForUserWithId(user!.uid)
                    }
                    
                    self.performSegueWithIdentifier(Storyboard.SignInSegueIdentifier, sender: nil)

                })
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    private func loadDummyDataForUserWithId(uid: String) {
        let userRef = FIRDatabase.database().reference().child("users").child(uid)
        let userValues: [String: AnyObject] = [
            "phoneNumber": "3059159192",
            "isModerator": true,
            "isOZ": false,
            "coordinates": [
                "latitude": 93.7,
                "longitude": -120.5,
            ],
            "clan": "clanId1",
            "team": "humans"
        ]
        userRef.updateChildValues(userValues)

    }
    
}
