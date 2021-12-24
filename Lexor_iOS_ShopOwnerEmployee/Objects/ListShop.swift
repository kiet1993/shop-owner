//
//  ListShop.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 22/09/2021.
//

import Foundation

// MARK: - Welcome
struct ListShopResponse: Decodable {
    let status: Int
    var data: ResponseClass
}

// MARK: - DataClass
struct ResponseClass: Decodable {
    let limit, page: Int
    let sort: String
    let totalRows, totalPages: Int
    var rows: [RowShop]

    enum CodingKeys: String, CodingKey {
        case limit, page, sort
        case totalRows = "total_rows"
        case totalPages = "total_pages"
        case rows
    }
}

// MARK: - Row
struct RowShop: Decodable {
    let id: Int
    let createdAt, updatedAt: Date?
    let uuid: String
    let tenantID: Int?
    let streetAddress1, streetAddress2, city, country: String
    let state, zipcode, phone, tax: String
    let occBusinessAccountUUID: String
    let isDefaultBillingAddress, isDefaultShippingAddress: Int
    let website: String
    let serviceWebAddress: String
    let isBusinessClosedMoved, isBusinessInsideMallAirport: Int
    var selectedShop: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uuid
        case tenantID = "tenant_id"
        case streetAddress1 = "street_address1"
        case streetAddress2 = "street_address2"
        case city, country, state, zipcode, phone, tax
        case occBusinessAccountUUID = "occ_business_account_uuid"
        case isDefaultBillingAddress = "is_default_billing_address"
        case isDefaultShippingAddress = "is_default_shipping_address"
        case website
        case serviceWebAddress = "service_web_address"
        case isBusinessClosedMoved = "is_business_closed_moved"
        case isBusinessInsideMallAirport = "is_business_inside_mall_airport"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        uuid = try container.decode(String.self, forKey: .uuid)
        createdAt = try? container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try? container.decodeIfPresent(Date.self, forKey: .updatedAt)
        tenantID = try container.decodeIfPresent(Int.self, forKey: .tenantID)
        streetAddress1 = try container.decode(String.self, forKey: .streetAddress1)
        streetAddress2 = try container.decode(String.self, forKey: .streetAddress2)
        city = try container.decode(String.self, forKey: .city)
        country = try container.decode(String.self, forKey: .country)
        state = try container.decode(String.self, forKey: .state)
        zipcode = try container.decode(String.self, forKey: .zipcode)
        phone = try container.decode(String.self, forKey: .phone)
        tax = try container.decode(String.self, forKey: .tax)
        occBusinessAccountUUID = try container.decode(String.self, forKey: .occBusinessAccountUUID)
        isDefaultBillingAddress = try container.decode(Int.self, forKey: .isDefaultBillingAddress)
        isDefaultShippingAddress = try container.decode(Int.self, forKey: .isDefaultShippingAddress)
        website = try container.decode(String.self, forKey: .website)
        serviceWebAddress = try container.decode(String.self, forKey: .serviceWebAddress)
        isBusinessClosedMoved = try container.decode(Int.self, forKey: .isBusinessClosedMoved)
        isBusinessInsideMallAirport = try container.decode(Int.self, forKey: .isBusinessInsideMallAirport)
    }
}

struct CreateShopResponse: Decodable {
    let status: Int
    let data: RowShop
}
