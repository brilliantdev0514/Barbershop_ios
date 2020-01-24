//
//  Extensions.swift
//  Ivan
//
//  Created by Olga Pirogova on 21.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//
import UIKit
extension UIViewController {
  func configureKeyboardDismissOnTap() {
    let keyboardDismissGesture = UITapGestureRecognizer(target: self,
                                                                                                              action: #selector(self.dismissKeyboard))

    view.addGestureRecognizer(keyboardDismissGesture)
  }

    @objc func dismissKeyboard() {
    // to be implemented inside your view controller(s) wanting to be able to dismiss the keyboard via tap gesture
        view.endEditing(true)
  }
}
