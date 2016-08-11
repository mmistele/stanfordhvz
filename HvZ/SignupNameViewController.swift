//
//  SignupNameViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Foundation

class SignupNameViewController: KeyboardAdaptiveViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldsStackView: UIStackView!
    
    @IBOutlet weak var firstNameField: UITextField! {
        didSet {
            firstNameField.delegate = self
        }
    }
    @IBOutlet weak var lastNameField: UITextField! {
        didSet {
            lastNameField.delegate = self
        }
    }
    
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let navcon = self.navigationController as? SignupNavigationController {
            navcon.firstName = firstNameField.text
            navcon.lastName = lastNameField.text
        }
        
     }
    
}
