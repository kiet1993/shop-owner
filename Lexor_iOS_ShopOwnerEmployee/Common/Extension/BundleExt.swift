//
//  BundleExt.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/24/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

extension Bundle {
    func hasNib(name: String) -> Bool {
        return path(forResource: name, ofType: "nib") != nil
    }
}
