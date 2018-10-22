//
//  UIViewExt.swift
//  fortune-rpg
//
//  Created by Malcolm Edwards on 2/10/18.
//  Copyright © 2018 Xenophile Games. All rights reserved.
//

import UIKit



extension UIView {
    
    func bindToKeyboard(_ tabHeight: CGFloat) {
        //self.tabHeight = tabHeight
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let tabHeight = CGFloat(49.0)
        let limitY = (superview?.frame.height)! - tabHeight
        
//        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
//        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
//        let startingFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endingFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        //let deltaY = endingFrame.origin.y + endingFrame.height > tabHeight ? endingFrame.origin.y  - startingFrame.origin.y : endingFrame.origin.y - startingFrame.origin.y - tabHeight
        //let deltaY = endingFrame.origin.y - startingFrame.origin.y
        let finalY = endingFrame.origin.y < limitY ? endingFrame.origin.y - self.frame.height : endingFrame.origin.y - self.frame.height - tabHeight

//        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
//            self.frame.origin.y = finalY
//        }, completion: nil)
//        debugPrint("changing frame, y = \(finalY)")
        self.frame.origin.y = finalY
    }
}

