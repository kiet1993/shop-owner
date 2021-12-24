//
//  PercentCircleView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class PercentCircleView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private weak var percentLabel: UILabel!
    @IBOutlet private weak var circleGraphView: CircleGraphView!

    // MARK: - Public functions
    func updateView(percent: CGFloat) {
        percentLabel.text = String(format: "%d%%", Int(percent))
        circleGraphView.percent = percent
    }
}
