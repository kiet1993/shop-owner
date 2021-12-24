//
//  NotificationCell.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 04/08/2021.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var disscription: UILabel!
    
    var viewModel: NotificationCellViewModel? {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateView() {
        titleLabel.text = viewModel?.title
        dateLabel.text = viewModel?.date
        disscription.text = viewModel?.discription
    }
}
