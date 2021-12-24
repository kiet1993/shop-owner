//
//  NewSimpleProductViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 19/08/2021.
//

import Foundation


struct CreateResult: Decodable {
    let status: Int
}
class NewSimpleProductViewModel {

    var sku: String = ""
    var createProduct: CreateProduct?

    func createProduct(completion: @escaping APICompletion) {
        APIRequest.createProduct(sku: sku) { [weak self] result in
            guard let this = self else {return}
            switch result {
            case .success(let value):
                this.createProduct = value
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
