//
//  Product.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 18/08/2021.
//

import Foundation

struct ResponeProduct: Decodable {
    let status: Int
    let data: Product
}

// MARK: - Product
struct Product: Decodable {
    let limit, page: Int
    let sort: String
    let totalRows, totalPages: Int
    let rows: [Row]

    enum CodingKeys: String, CodingKey {
        case limit, page, sort
        case totalRows = "total_rows"
        case totalPages = "total_pages"
        case rows
    }
}

// MARK: - Row
struct Row: Decodable {
    let id : Int
    let createdAt, updatedAt: Date?
    let uuid: String
    let attributeSetID: Int
    let typeID: String
    let sku: String
    let hasOptions, requiredOptions: Int

    enum CodingKeys: String, CodingKey {
        case id
        case uuid, sku
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case attributeSetID = "attribute_set_id"
        case typeID = "type_id"
        case hasOptions = "has_options"
        case requiredOptions = "required_options"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        sku = try container.decode(String.self, forKey: .sku)
        uuid = try container.decode(String.self, forKey: .uuid)
        createdAt = try? container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try? container.decodeIfPresent(Date.self, forKey: .updatedAt)
        attributeSetID = try container.decode(Int.self, forKey: .attributeSetID)
        hasOptions = try container.decode(Int.self, forKey: .hasOptions)
        requiredOptions = try container.decode(Int.self, forKey: .requiredOptions)
        typeID = try container.decode(String.self, forKey: .typeID)
    }
}
