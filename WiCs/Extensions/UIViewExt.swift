//
//  UIViewExt.swift
//  WiCs
//
//  Created by Edward Palermo on 1/27/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import Foundation

import UIKit


//Extenending capabilities of UIView
extension UIView
{
    /*
     * Notification Center, adds observer, for whenever keybaord change frame notification is called.
     * sets observer to perform an action

     * self because button observes and that how we get the object
     * called before keyboard changes frames so that it animates ith the keyboard
     */
    func bindToKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame,object: nil)
    }
    
    /*
     * allows us to send a value for the obejest to call the function, we pass
     * this as a notification,, it gets the frame of keywork, animates
     8 objc: expose function to objective C
     */
    @objc func keyboardWillChange(_ notification: NSNotification)
    {
        /*
         * duration: pulls duration of keyboard animation, and set it the same
         *           to the duration duration  of the button to animate the same
         *            UIKeyboardAnimationDurationUserInfoKey
         *
         * curve: every animation has a curve: animation comes to hault or
         *        begins. starts slowly, and increasing speed in a short of time.
         *
         *
         * beginningFrame: set up frame at beggning and at end frame. !(unwrap it)
         * [whoop out the keyboard] .cgRect is pulled and casted as! nsvalue
         *
         * deltaY: monitor change on y -axis, take beginningFrame, and subtract endFrame
         *          takes the y value and subtract so we know exactly how far the keyboard moves up
         *
         *
         */
        let duration = notification.userInfo! [UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        // UIViewKeyframeAnimationOptions(rawValue: curve) -> UInt expecting an option set.
        // We told it to have the same animation curve as the keyboard.
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve),animations:
            
            {
            self.frame.origin.y += deltaY //move up however much the keyboard moves up, takes the Y value of the UIView, and sticks with keyboard and slides up with it.
                                }, completion: nil)
    }
}

//Current code for the app i
// is below!!




