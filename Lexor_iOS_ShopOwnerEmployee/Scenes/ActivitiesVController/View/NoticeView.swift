//
//  NoticeView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 05/08/2021.
//

import UIKit
import SnapKit

protocol NoticeViewDelegate: AnyObject {
    func view(_ view: NoticeView, needPerformAction action: NoticeView.Action)
}

class NoticeView: UIView {
    
    
    enum Action {
        case deleteNotice
        case turnOffAllert
    }
    
    weak var delegate: NoticeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("NoticeView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    @IBAction func clearButtonTouchUpInside(_ sender: Any) {
        delegate?.view(self, needPerformAction: .deleteNotice)
    }
    
    @IBAction func closeAlertButtonTouchUpInside(_ sender: Any) {
        delegate?.view(self, needPerformAction: .turnOffAllert)
    }
    
}
