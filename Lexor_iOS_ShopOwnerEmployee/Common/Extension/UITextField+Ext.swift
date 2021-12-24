//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UITextField {
    func setUpTextFieldInput(placeholder: String, widthLeftView: CGFloat = 8, widthRightView: CGFloat = 0) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: widthLeftView, height: self.frame.size.height))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: widthRightView, height: self.frame.size.height))
        self.leftView = leftView
        self.leftViewMode = .always
        if widthRightView != 0 {
            self.rightView = rightView
            self.rightViewMode = .always
        }
        self.placeholder = placeholder
        self.clearButtonMode = .whileEditing
    }
    
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTouchUpInside))
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }

    @objc func doneButtonTouchUpInside(_ sender: UIBarButtonItem) {
        resignFirstResponder()
    }
}
