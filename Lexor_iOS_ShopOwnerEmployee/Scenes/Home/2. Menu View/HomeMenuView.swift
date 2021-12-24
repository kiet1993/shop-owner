//
//  HomeMenuView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran on 8/4/21.
//

import UIKit

final class HomeMenuView: BaseView {

    // MARK: - IBOutlets
    /// `Profile`
    @IBOutlet private weak var profileIconImageView: UIImageView!
    @IBOutlet private weak var profileTitleLabel: UILabel!
    /// `Messenger`
    @IBOutlet private weak var messengerIconImageView: UIImageView!
    @IBOutlet private weak var messengerTitleLabel: UILabel!
    /// `Shop Selection`
    @IBOutlet private weak var shopIconImageView: UIImageView!
    @IBOutlet private weak var shopTitleLabel: UILabel!

    // MARK: - Properties
    var profileTapHandler: (() -> Void)?
    var messengerTapHandler: (() -> Void)?
    var shopSelectionTapHandler: (() -> Void)?

    // MARK: - IBActions
    @IBAction private func profileButtonTouchUpInside(_ button: UIButton) {
        profileTapHandler?()
    }

    @IBAction private func messengerButtonTouchUpInside(_ button: UIButton) {
        messengerTapHandler?()
    }

    @IBAction private func shopSelectionButtonTouchUpInside(_ button: UIButton) {
        shopSelectionTapHandler?()
    }
}
