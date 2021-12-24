//
//  GroupItemView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran on 8/5/21.
//

import UIKit

final class GroupItemView: BaseView {

    typealias ItemInfo = HomeViewModel.ItemInfo

    // MARK: - IBOutlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    var itemInfo: ItemInfo?
    var tapHandler: ((ItemInfo) -> Void)?

    // MARK: - Public functions
    func updateView(with itemInfo: ItemInfo) {
        /// - Cache data
        self.itemInfo = itemInfo

        /// - Setup fixed UI
        setupUI()

        /// - Update UI
        iconImageView.image = itemInfo.iconImage
        titleLabel.text = itemInfo.title
    }

    // MARK: - IBActions
    @IBAction private func containerButtonTouchUpInside(_ button: UIButton) {
        guard let itemInfo = itemInfo else { return }
        tapHandler?(itemInfo)
    }
}

// MARK: - Extension GroupItemView
extension GroupItemView {

    // MARK: - Private functions
    private func setupUI() {
        titleLabel.textColor = UIColor.textDarkGray
    }
}
