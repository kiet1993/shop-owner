//
//  CreateProduct.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 19/08/2021.
//

import Foundation

struct CreateProduct: Codable {
    let status: Int
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let createdAt, updatedAt, uuid: String
    let attributeSetID: Int
    let typeID, sku: String
    let hasOptions, requiredOptions: Int

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uuid
        case attributeSetID = "attribute_set_id"
        case typeID = "type_id"
        case sku
        case hasOptions = "has_options"
        case requiredOptions = "required_options"
    }
}
