//
//  StarRatingView.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/24/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class StarRatingView: BaseView {

    // MARK: - IBOutlets
    @IBOutlet private var starViews: [UIView]!

    // MARK: - Public functions
    func updateView(with ratingCount: Int = 0) {
        starViews.forEach({
            /// ratingCount `-1` because it's the value, not the index (begin from 0)
            let isShow = $0.tag <= ratingCount - 1
            $0.isHidden = !isShow
        })
    }
}
