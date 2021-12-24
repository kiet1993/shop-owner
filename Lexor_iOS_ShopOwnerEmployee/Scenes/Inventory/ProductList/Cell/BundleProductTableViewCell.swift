//
//  BundleProductTableViewCell.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import UIKit

class BundleProductTableViewCell: UITableViewCell {
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelProductList: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerView.layer.cornerRadius = 15
        btnEdit.tintColor = UIColor.primaryPink
        btnEdit.setImage(btnEdit.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnDelete.tintColor = UIColor.primaryPink
        btnDelete.setImage(btnDelete.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func configCell(model: BundleProductModelType) {
        productName.text = model.name
        labelPrice.text = model.price
        labelQuantity.text = "\(model.quantity)"
        labelProductList.text = model.productList
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
    }
    
}
