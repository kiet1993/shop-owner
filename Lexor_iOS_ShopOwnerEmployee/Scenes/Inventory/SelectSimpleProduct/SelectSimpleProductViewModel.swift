//
//  SelectSimpleProductViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/9/21.
//

import Foundation

protocol SelectSimpleProductViewModelType {
    var delegate: SelectSimpleProductViewModelDelegate? { get set}
    var simpleProducts: [SimpleProductModel] { get set }
    var filteredSimpleProducts: [SimpleProductModel] { get set }
    
    func didSelectItemWith(_ id: Int)
    func checkSelectedProducts()
}

protocol SelectSimpleProductViewModelDelegate: AnyObject {
    func reloadTableView()
    func setSelectedProductLabel(_ text: String)
}

class SelectSimpleProductViewModel: SelectSimpleProductViewModelType {
    weak var delegate: SelectSimpleProductViewModelDelegate?
    
    var filteredSimpleProducts: [SimpleProductModel] = []
    var simpleProducts = [SimpleProductModel(id: 0,
                                             name: "Product 1",
                                             price: "10.00",
                                             quantity: 2),
                          SimpleProductModel(id: 1,
                                             name: "Product 2",
                                             price: "13.00",
                                             quantity: 29),
                          SimpleProductModel(id: 2,
                                             name: "Product 3",
                                             price: "11.00",
                                             quantity: 10),
                          SimpleProductModel(id: 3,
                                             name: "Product 4",
                                             price: "15.00",
                                             quantity: 2),
                          SimpleProductModel(id: 4,
                                             name: "Product 5",
                                             price: "16.00",
                                             quantity: 3),
    ]
    
    init(selectedIds: [Int]) {
        simpleProducts.indices.forEach { index in
            if selectedIds.contains(simpleProducts[index].id) {
                simpleProducts[index].isSelect = true
            }
        }
    }
    
    func checkSelectedProducts() {
        delegate?.setSelectedProductLabel(simpleProducts.filter({$0.isSelect}).map({$0.name}).joined(separator: ", "))
    }
    
    func didSelectItemWith(_ id: Int) {
        filteredSimpleProducts.indices.forEach { index in
            if filteredSimpleProducts[index].id == id {
                filteredSimpleProducts[index].isSelect = !filteredSimpleProducts[index].isSelect
            }
        }
        simpleProducts.indices.forEach { index in
            if simpleProducts[index].id == id {
                simpleProducts[index].isSelect = !simpleProducts[index].isSelect
            }
        }
        let text = simpleProducts.filter({$0.isSelect}).map({$0.name}).joined(separator: ", ")
        delegate?.setSelectedProductLabel(text)
        delegate?.reloadTableView()
    }
}
