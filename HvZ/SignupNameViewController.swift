//
//  SignupNameViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/4/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit
import Foundation

class SignupNameViewController: UIViewController, UITextFieldDelegate {
    
    private var centerYConstraint: NSLayoutConstraint?
    private var keyboardConstraint: NSLayoutConstraint?
    private var keyboardShowObserver: NSObjectProtocol?
    private var keyboardHideObserver: NSObjectProtocol?
    private var bottomConstraint: NSLayoutConstraint?
    private let keyboardSeparation = CGFloat(10) // how many pixels to separate the stack view from the keyboard
    
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
        centerYConstraint = NSLayoutConstraint(
            item: textFieldsStackView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0)
        view.addConstraint(centerYConstraint!)
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardShowAnimation()
        subscribeToKeyboardHideAnimation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(keyboardShowObserver!)
        NSNotificationCenter.defaultCenter().removeObserver(keyboardHideObserver!)
    }
    
    /*
     * Handle keyboard coming in and obscuring the view
     */
    private func subscribeToKeyboardShowAnimation() {
        let center = NSNotificationCenter.defaultCenter()
        keyboardShowObserver = center.addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            [weak self] (notification) in
            if self != nil {
                
                // Get end location of the keyboard
                // Following two lines adapted from http://stackoverflow.com/questions/25091765/how-to-get-a-value-from-nsvalue-in-swift
                if let endFrameOptional = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as? NSValue {
                    let endFrame = endFrameOptional.CGRectValue()
                    
                    let spaceForKeyboard = self!.view.bounds.maxY - self!.textFieldsStackView.frame.maxY
                    if endFrame.height < spaceForKeyboard {
                        // Do nothing, we're ok
                        return
                    }
                    
                    self!.view.layoutIfNeeded()
                    
                    // Detach view from the center
                    if let oldConstraint = self!.centerYConstraint {
                        self!.view.removeConstraint(oldConstraint)
                    }
                    
                    // Set end keyframe to being 10 pixels away from
                    self!.bottomConstraint = NSLayoutConstraint(
                        item: self!.textFieldsStackView,
                        attribute: .Bottom,
                        relatedBy: .Equal,
                        toItem: self!.view,
                        attribute: .Bottom,
                        multiplier: 1,
                        constant: 0 - endFrame.height - self!.keyboardSeparation)
                    
                    self!.view.addConstraint(self!.bottomConstraint!)
                    
                    var animationDuration = 3.0
                    if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                        animationDuration = duration
                    }
                    // Adapted from http://stackoverflow.com/questions/12622424/how-do-i-animate-constraint-changes
                    UIView.animateWithDuration(animationDuration) {
                        self!.view.layoutIfNeeded()
                    }
                    
                }
            }
            })
    }
    
    /*
     * Reset to centered constraints
     */
    private func subscribeToKeyboardHideAnimation() {
        let center = NSNotificationCenter.defaultCenter()
        keyboardHideObserver = center.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            [weak self] (notification) in
            if self != nil {
                
                self!.view.layoutIfNeeded()
                
                // Detach view from the center
                if let oldConstraint = self!.bottomConstraint {
                    self!.view.removeConstraint(oldConstraint)
                }
                
                self!.view.addConstraint(self!.centerYConstraint!)
                
                var animationDuration = 3.0
                if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
                    animationDuration = duration
                }
                // Adapted from http://stackoverflow.com/questions/12622424/how-do-i-animate-constraint-changes
                UIView.animateWithDuration(animationDuration) {
                    self!.view.layoutIfNeeded()
                }
            }
            
            })
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Get the info from it
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
