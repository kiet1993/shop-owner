//
//  HomeHeaderView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran on 8/4/21.
//

import UIKit

final class HomeHeaderView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Public functions
    func updateView(with viewModel: HomeHeaderViewModel) {
        avatarImageView.image = viewModel.avatarImage
        userNameLabel.text = viewModel.userName
        pointLabel.text = String(format: "%d point", viewModel.point)
    }
}

// MARK: - Extension HomeHeaderView
extension HomeHeaderView {

    // MARK: - Private functions
    private func setupUI() {
        avatarImageView.layer.borderWidth = 4
        avatarImageView.layer.borderColor = UIColor.contentPink.cgColor

        userNameLabel.textColor = UIColor.textDarkGray
        pointLabel.textColor = UIColor.textDarkGray
    }
}
