//
//  Button.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 23/05/2021.
//

import UIKit

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private var selectedBackgroundColor: UIColor?
    private var normalBackgroundColor: UIColor?
    private var disableBackgroundColor: UIColor?
    private var hightlightBackgroundColor: UIColor?

    func setBackgroundColor(color: UIColor?, state: UIControl.State) {
        switch state {
        case .normal:
            normalBackgroundColor = color
        case .selected:
            selectedBackgroundColor = color
        case .disabled:
            disableBackgroundColor = color
        case .highlighted:
            adjustsImageWhenHighlighted = false
            hightlightBackgroundColor = color
        default:
            break
        }
        guard let color = color else { return }
        setBackgroundImage(self.imageWithColor(color: color), for: state)
    }
}
