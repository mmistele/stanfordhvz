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
            if let player = Player.playerWithUniqueId(generateUnique(), inContext: managedObjectContext!) {
                player.cellNumber = navcon.newUserCellNumber
                player.password = navcon.newUserPassword
                player.firstName = navcon.firstName
                player.lastName = navcon.lastName
                appDelegate?.currentUser = player
                
                // Dummy data for now
                player.image = DummyStore.SampleProfileImages![0]
                player.isModerator = false
                player.isOZ = false
                player.latitude = 37.423087
                player.longitude = -122.160908
                player.clan = Clan.clanNamed("CS193P", inManagedObjectContext: managedObjectContext!)
                player.badges = NSArray(array: [])
                player.teamName = "Humans"
                player.team = Team.teamNamed(player.teamName!, inManagedObjectContext: managedObjectContext!)
                
            }
        }
       
        navigationController?.removeFromParentViewController()
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
