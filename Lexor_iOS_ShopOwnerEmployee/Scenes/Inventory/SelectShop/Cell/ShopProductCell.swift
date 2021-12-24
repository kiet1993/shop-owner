//
//  ShopProductCell.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 21/08/2021.
//

import UIKit

final class ShopProductCell: UITableViewCell {

    @IBOutlet private  weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private  weak var nameLabel: UILabel!
    @IBOutlet private weak var checkBoxImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 15
        checkBoxImageView.layer.cornerRadius = checkBoxImageView.bounds.height / 2
        checkBoxImageView.layer.borderWidth = 1
        checkBoxImageView.layer.borderColor = UIColor.primaryPink.cgColor
        checkBoxImageView.tintColor = UIColor.primaryPink
    }

    func configCell(isSelect: Bool, nameStr: String) {
        checkBoxImageView.image = isSelect ? #imageLiteral(resourceName: "ic-check").withRenderingMode(.alwaysTemplate) : nil
        nameLabel.text = nameStr
    }
}
