//
//  PromotionCell.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 12/10/2021.
//

import UIKit

protocol PromotionCellDelegate: NSObjectProtocol {
    func didChangeOnOffPromotion(isOn: Bool)
    func didTapShowInfoPromotion(promotion: PromotionType)
}

class PromotionCell: UICollectionViewCell {
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onOffPromotionSwitch: UISwitch!
    @IBOutlet weak var namePromotionLabel: UILabel!
    @IBOutlet weak var dateTimePromotionLabel: UILabel!
    @IBOutlet weak var iconCalendarImageView: UIImageView!
    @IBOutlet weak var applyToChannelsLabel: UILabel!
    @IBOutlet weak var applyToLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var deletePromotionButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    weak var delegate: PromotionCellDelegate?
    private var formatStringDate = "dd/MM/yyyy"
    private var promotion: PromotionType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconCalendarImageView.image = UIImage(named: "ic-calendar")?.withRenderingMode(.alwaysTemplate)
        iconCalendarImageView.tintColor = .black
        
        infoButton.tintColor = .black
        deletePromotionButton.tintColor = .black
        
        backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.layer.applySketchShadow(color: .black, alpha: 0.1, xOrigin: 0, yOrigin: 4, blur: 10, spread: 0)
    }
    
    func setData(promotion: Promotion) {
        self.promotion = promotion
        titleLabel.text = promotion.programName
        namePromotionLabel.text = promotion.programName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStringDate
        let nsMutableString = NSMutableAttributedString(string: "Start date: ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .medium)])
        let startDateAttributeString = NSAttributedString(string: dateFormatter.string(from: promotion.startDate),
                                                          attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .medium)])
        let titleEndDateAttributeString = NSAttributedString(string: " - End date: ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .medium)])
        let endDateAttributeString = NSAttributedString(string: dateFormatter.string(from: promotion.endDate),
                                                        attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .medium)])
        nsMutableString.append(startDateAttributeString)
        nsMutableString.append(titleEndDateAttributeString)
        nsMutableString.append(endDateAttributeString)
        dateTimePromotionLabel.attributedText = nsMutableString
        
        applyToChannelsLabel.text = "Apply to channels: \(promotion.channelApplied)"
        applyToLabel.text = "Apply to: \(promotion.applyTo)"
        creatorLabel.text = "Creator: \(promotion.creator)"
        
        onOffPromotionSwitch.isOn = promotion.isOn
        detailView.isHidden = !promotion.isExpanded
    }
    
    @IBAction func didChangeOnOffPromotion(_ sender: Any) {
        delegate?.didChangeOnOffPromotion(isOn: onOffPromotionSwitch.isOn)
    }
    
    @IBAction func didTapDeletePromotion(_ sender: Any) {
    }
    
    @IBAction func didTapInfoPromotion(_ sender: Any) {
        guard var promotion = promotion else { return }
        promotion.isExpanded.toggle()
        delegate?.didTapShowInfoPromotion(promotion: promotion)
    }
}
