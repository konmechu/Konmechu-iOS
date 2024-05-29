//
//  UIViewExtension.swift
//  konmechu
//
//  Created by 정재연 on 5/29/24.
//

import UIKit

extension UIView {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
