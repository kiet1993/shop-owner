//
//  ActivityView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/25/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class ActivityView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var percentCircleView: PercentCircleView!
    @IBOutlet private weak var itemContainerView: UIView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    @IBOutlet private weak var itemDescriptionLabel: UILabel!
    @IBOutlet private weak var itemSubmitButton: UIButton!
    @IBOutlet private weak var itemCloseButton: UIButton!

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        percentCircleView.updateView(percent: 80)
    }

    // MARK: - IBActions
    @IBAction private func itemSubmitButtonTouchUpInside(button: UIButton) {
        print("Tapped itemSubmitButton")
    }

    @IBAction private func itemCloseButtonTouchUpInside(button: UIButton) {
        print("Tapped itemCloseButton")
    }
}

// MARK: - Extension ActivityView
extension ActivityView {

    // MARK: - Private functions
    private func configUI() {
        /// Shadow & Border for view
        itemContainerView.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        itemContainerView.layer.shadowRadius = 5
        itemContainerView.layer.shadowOffset = .zero
        itemContainerView.layer.shadowOpacity = 1
        itemContainerView.layer.cornerRadius = 5

        /// Border for button
        itemSubmitButton.layer.cornerRadius = 5
        itemSubmitButton.layer.borderWidth = 1
        itemSubmitButton.layer.borderColor = UIColor.activeBlue.cgColor
    }
}
