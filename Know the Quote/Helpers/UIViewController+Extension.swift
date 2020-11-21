//
//  UIViewController+Extension.swift
//  Know the Quote
//
//  Created by macbook on 11/17/20.
//

import UIKit

// Hide Keyboard after tapping anywhere on the screen
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
