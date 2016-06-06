//
//  SignupPasswordViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

class SignupPasswordViewController: KeyboardAdaptiveViewController, UITextFieldDelegate {

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
