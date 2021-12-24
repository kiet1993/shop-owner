//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setUpImageWithSDWebImage() {
        let sdLoadImageIndicator = SDWebImageActivityIndicator()
        sdLoadImageIndicator.indicatorView.color = .basBluePastel
        self.sd_imageIndicator = sdLoadImageIndicator
        self.sd_imageTransition = .fade
    }
}
