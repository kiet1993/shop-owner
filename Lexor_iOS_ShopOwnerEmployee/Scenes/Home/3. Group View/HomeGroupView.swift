//
//  HomeGroupView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran on 8/5/21.
//

import UIKit

final class HomeGroupView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var itemStackView: UIStackView!

    // MARK: - Properties
    var itemTapHandler: ((HomeViewModel.ItemInfo) -> Void)? {
        didSet {
            /// - `Setup tap handler closure)
            itemStackView.arrangedSubviews.forEach({
                ($0 as? GroupItemView)?.tapHandler = itemTapHandler
            })
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Public functions
    func updateView(with viewModel: HomeGroupViewModel) {
        /// - Setup fixed UI
        setupUI()

        /// `Title label`
        titleLabel.text = viewModel.title

        /// `Stack view subviews`
        viewModel.items.forEach({
            let view = GroupItemView()
            view.updateView(with: $0)
            itemStackView.addArrangedSubview(view)
        })
    }
}

// MARK: - Extension HomeGroupView
extension HomeGroupView {

    // MARK: - Private functions
    private func setupUI() {
        titleLabel.textColor = UIColor.textDarkGray

        containerView.cornerRadius = 10
    }
}
