//
//  UIViewController|.swift
//  Image Gallery
//
//  Created by aleksandre on 21.06.22.
//

import UIKit

extension UIViewController
{
    /// Hide keyboard when taps occur on the screen
    func hideKeyboardOnTouches() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
