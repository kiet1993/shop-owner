//
//  ProductListViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import Foundation
enum ProductListScreenType {
    case simple
    case bundle
}

protocol SimpleProductModelType {
    var id: Int { get }
    var name: String { get }
    var price: String { get }
    var quantity: Int { get }
}

protocol BundleProductModelType: SimpleProductModelType {
    var productList: String { get }
}

struct SimpleProductModel: SimpleProductModelType {
    var id: Int
    var name: String
    var price: String
    var quantity: Int
    var isSelect = false
}

struct BundleProductModel: BundleProductModelType {
    var id: Int
    var name: String
    var price: String
    var quantity: Int
    var productList: String
}

//protocol ProductListViewModelType {
//    var screenType: ProductListScreenType { get set }
//    var filteredSimpleProducts: [SimpleProductModel] { get set }
//    var filteredBundleProducts: [BundleProductModel] { get set }
//    var simpleProducts: [SimpleProductModel] { get }
//    var bundleProducts: [BundleProductModel] { get }
//}

class ProductListViewModel {

    var respontProduct: ResponeProduct? {
        didSet {
            tranfer()
        }
    }

    var filteredSimpleProducts: [Row] = []
    var filteredBundleProducts: [Row] = []

    var screenType: ProductListScreenType = .simple

    func tranfer() {
        guard let listProduct = respontProduct?.data.rows else { return}
        filteredSimpleProducts = listProduct.filter({$0.typeID == "simple"})
        filteredBundleProducts = listProduct.filter({$0.typeID == "bundle"})
    }

    func getListProduct(completion: @escaping APICompletion) {
        APIRequest.listProduct{ [weak self] result in
            guard let this = self else {return}
            switch result {
            case .success(let value):
                this.respontProduct = value
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
}




//    var filteredSimpleProducts: [SimpleProductModel] = []
//    var filteredBundleProducts: [BundleProductModel] = []
////
//    var screenType: ProductListScreenType = .bundle
//    var simpleProducts = [SimpleProductModel(id: 0,
//                                             name: "Product 1",
//                                             price: "10.00",
//                                             quantity: 2),
//                          SimpleProductModel(id: 1,
//                                             name: "Product 2",
//                                             price: "13.00",
//                                             quantity: 29),
//                          SimpleProductModel(id: 2,
//                                             name: "Product 3",
//                                             price: "11.00",
//                                             quantity: 10),
//                          SimpleProductModel(id: 3,
//                                             name: "Product 4",
//                                             price: "15.00",
//                                             quantity: 2),
//                          SimpleProductModel(id: 4,
//                                             name: "Product 5",
//                                             price: "16.00",
//                                             quantity: 3),
//    ]
//
//    var bundleProducts = [BundleProductModel(id: 0,
//                                             name: "Bundle Product",
//                                             price: "12.00",
//                                             quantity: 3,
//                                             productList: "Product 1, product 2, product 3, Product 6, product 5, product 4"),
//                          BundleProductModel(id: 1,
//                                             name: "Bundle Product 1",
//                                             price: "9.00",
//                                             quantity: 2,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 2,
//                                             name: "Bundle Product 2",
//                                             price: "1.00",
//                                             quantity: 6,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 3,
//                                             name: "Bundle Product 3",
//                                             price: "12.00",
//                                             quantity: 5,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 4,
//                                             name: "Bundle Product 4",
//                                             price: "19.00",
//                                             quantity: 2,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 5,
//                                             name: "Bundle Product 5",
//                                             price: "12.00",
//                                             quantity: 3,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 6,
//                                             name: "Bundle Product 6",
//                                             price: "12.00",
//                                             quantity: 2,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 7,
//                                             name: "Bundle Product 7",
//                                             price: "12.00",
//                                             quantity: 8,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 8,
//                                             name: "Bundle Product 8",
//                                             price: "12.00",
//                                             quantity: 9,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 9,
//                                             name: "Bundle Product 9",
//                                             price: "12.00",
//                                             quantity: 24,
//                                             productList: "Product 1, product 2, product 3"),
//                          BundleProductModel(id: 10,
//                                             name: "Bundle Product 10",
//                                             price: "12.00",
//                                             quantity: 21,
//                                             productList: "Product 1, product 2, product 3"),
//    ]
//    init(screenType: ProductListScreenType) {
//        self.screenType = screenType
//    }
//}
