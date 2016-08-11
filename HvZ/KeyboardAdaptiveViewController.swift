//
//  KeyboardAdaptiveViewController.swift
//  HvZ
//
//  Created by Matthew Mistele on 6/5/16.
//  Copyright © 2016 Matthew Mistele. All rights reserved.
//

import UIKit

/** 
 * Moves its adaptingView up and out of the way of the keyboard when the keyboard
 * would otherwise cover it.
 * To avoid constraint conflicts, set the priority of the constraint this move would break
 * to a value less than 1000 (UILayoutPriorityRequired).
 */

class KeyboardAdaptiveViewController: UIViewController {
    
    private var adaptToKeyboardConstraint: NSLayoutConstraint!
    
    // How many pixels to separate the stack view from the keyboard
    internal var keyboardSeparation = CGFloat(0)
    
    /// The view that changes its edge insets to not be covered by the keyboard
    @IBOutlet weak var adaptingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adaptToKeyboardConstraint = NSLayoutConstraint(
            item: adaptingView,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0)
        
        adaptToKeyboardConstraint.priority = UILayoutPriorityRequired
        adaptToKeyboardConstraint.active = false
        view.addConstraint(adaptToKeyboardConstraint)

    }
    
    /*
     * Subscribes each time view will appear, except it won't work the first time -
     * need to also have subclass call subscribeToKeyboardAnimations() once it's loaded,
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardAnimations()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardAnimations()
    }
    
    
    /*
     * The following functions are called on view appear and disappear, and can be called
     * at other times by subclasses if needed (or by other classes if REALLY needed)
     */
    internal func subscribeToKeyboardAnimations() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
    }
    internal func unsubscribeFromKeyboardAnimations() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        
        view.layoutIfNeeded()
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as! NSValue).CGRectValue()
        
        // If the screen is rotated, keyboardScreenEndFrame is flipped from the frame we want in the view's coordinates.
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        if notification.name == UIKeyboardWillHideNotification {
            adaptToKeyboardConstraint.active = false
        }
        else if notification.name == UIKeyboardWillChangeFrameNotification {
            let spaceForKeyboard = view.bounds.maxY - adaptingView.frame.maxY
            adaptToKeyboardConstraint.constant = 0 - keyboardViewEndFrame.height - keyboardSeparation
            
            if keyboardViewEndFrame.height >= spaceForKeyboard {
                adaptToKeyboardConstraint.active = true
            }
        }
        var animationDuration = 3.0
        if let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            animationDuration = duration
        }
        UIView.animateWithDuration(animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}