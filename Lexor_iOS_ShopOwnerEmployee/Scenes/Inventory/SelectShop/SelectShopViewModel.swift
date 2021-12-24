//
//  SelectShopViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 21/08/2021.
//

import Foundation

enum ShopScreenType {
    case shop1
    case shop2
}

struct ListShopModel {
    var id: Int
    var name: String
    var isSelect = false
}

protocol SelectShopViewModelDelegate: AnyObject {
    func reloadTableView()
}

class SelectShopViewModel {

    weak var delegate: SelectShopViewModelDelegate?

    var shopList: [RowShop]  = [] 
    
    func didSelectItemWith(_ id: Int) {
        shopList.indices.forEach {index in
            if index == id {
                shopList[index].selectedShop = true
            } else {
                shopList[index].selectedShop = false
            }
        }
        delegate?.reloadTableView()
    } 
}
