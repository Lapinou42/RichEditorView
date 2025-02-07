//
//  KeyboardManager.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import RichEditorView

/**
    KeyboardManager is a class that takes care of showing and hiding the RichEditorToolbar when the keyboard is shown.
    As opposed to having this logic in multiple places, it is encapsulated in here. All that needs to change is the parent view.
*/
class KeyboardManager: NSObject {

    /**
        The parent view that the toolbar should be added to.
        Should normally be the top-level view of a UIViewController
    */
    weak var view: UIView?

    /**
        The toolbar that will be shown and hidden.
    */
    var toolbar: RichEditorToolbar

    init(view: UIView, toolbar: RichEditorToolbar) {
        
        self.view = view
        self.toolbar = toolbar
        
        super.init()
    }

    /**
        Starts monitoring for keyboard notifications in order to show/hide the toolbar
    */
    func beginMonitoring() {
        let sel = #selector(keyboardWillShowOrHide(_:))
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /**
        Stops monitoring for keyboard notifications
    */
    func stopMonitoring() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /**
        Called when a keyboard notification is recieved. Takes are of handling the showing or hiding of the toolbar
    */
    @objc func keyboardWillShowOrHide(_ notification: Notification) {
        let info = notification.userInfo ?? [:]
        let duration = TimeInterval((info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.floatValue ?? 0.25)
        let curve = UInt((info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0)
        let options = UIView.AnimationOptions(rawValue: curve)
        let keyboardRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero

        if notification.name == UIResponder.keyboardWillShowNotification {
            self.view?.addSubview(self.toolbar)
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                if let view = self.view {
                    self.toolbar.frame.origin.y = view.frame.height - (keyboardRect.height + self.toolbar.frame.height)
                    view.layoutIfNeeded()
                }
            }, completion: nil)


        } else if notification.name == UIResponder.keyboardWillHideNotification {
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                if let view = self.view {
                    self.toolbar.frame.origin.y = view.frame.height
                    view.layoutIfNeeded()
                }
            }, completion: nil)
        }
    }
}
