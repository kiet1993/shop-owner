//
//  InboxView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/25/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class InboxView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Properties
    var tapCloseHandler: (() -> Void)?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    // MARK: - IBActions
    @IBAction private func closeButtonTouchUpInside(button: UIButton) {
        tapCloseHandler?()
    }
}

// MARK: - Extension InboxView
extension InboxView {

    // MARK: - Private functions
    private func configUI() {
        /// Description label
        let fullText = "Give customers the latest about your health and safety measures, offerings, and hours. Update now"
        let highlightText = "Update now"
        /// - Range
        let highlightRange = (fullText as NSString).range(of: highlightText)
        let attributeString = NSMutableAttributedString(string: fullText)
        /// - Setup attributes
        attributeString.addAttributes([
            .font: UIFont.boldSystemFont(ofSize: descriptionLabel.font.pointSize),
            .foregroundColor: UIColor.activeBlue
        ], range: highlightRange)
        /// - Apply attributes
        descriptionLabel.attributedText = attributeString
    }
}
