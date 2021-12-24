//
//  SimpleProductTableViewCell.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import UIKit

class SimpleProductTableViewCell: UITableViewCell {
    enum CellType {
        case select
        case edit
    }
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var icSelect: UIImageView!
    
    private var type: CellType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerView.layer.cornerRadius = 15
        btnEdit.tintColor = UIColor.primaryPink
        btnEdit.setImage(btnEdit.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnDelete.tintColor = UIColor.primaryPink
        btnDelete.setImage(btnDelete.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        icSelect.layer.cornerRadius = 13
        icSelect.layer.borderWidth = 1
        icSelect.layer.borderColor = UIColor.primaryPink.cgColor
        icSelect.tintColor = UIColor.primaryPink
    }
    
    func configCell(model: SimpleProductModel, type: CellType) {
        productName.text = model.name
        labelPrice.text = model.price
        labelQuantity.text = "\(model.quantity)"
        self.type = type
        
        switch type {
        case .select:
            btnEdit.isHidden = true
            btnDelete.isHidden = true
            icSelect.isHidden = false
            icSelect.image = model.isSelect ? #imageLiteral(resourceName: "ic-check").withRenderingMode(.alwaysTemplate) : nil
        case .edit:
            btnEdit.isHidden = false
            btnDelete.isHidden = false
            icSelect.isHidden = true
        }
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
    }
    
}
