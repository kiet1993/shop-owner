//
//  DummyListProductCell.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 19/08/2021.
//

import UIKit

class DummyListProductCell: UITableViewCell {

    @IBOutlet private weak var skuLabel: UILabel!
    @IBOutlet private weak var typeIDLabel: UILabel!
    @IBOutlet private weak var uuidLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configCell(skuString: String,
                    typeIDString: String,
                    uuddString: String
    ) {
        skuLabel.text = skuString
        typeIDLabel.text = typeIDString
        uuidLabel.text = uuddString
    }
}
