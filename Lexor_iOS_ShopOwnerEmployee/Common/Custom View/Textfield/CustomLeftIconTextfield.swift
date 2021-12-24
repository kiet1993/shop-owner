//
//  CustomLeftIconTextfield.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import UIKit

class CustomLeftIconTextfield: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 5) {
        didSet {
            self.layoutIfNeeded()
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
            textRect.origin.x += 10
            return textRect
    }
}
