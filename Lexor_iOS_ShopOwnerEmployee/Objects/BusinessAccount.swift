//
//  BusinessAccount.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 13/10/2021.
//

import UIKit

struct BusinessAccountResponse: Decodable {
    let status: Int
    var data: BusinessAccount
}

struct BusinessAccount: Codable {
    var id: Int
    var createdAt: String?
    var updatedAt: String?
    var uuid: String
    var firstName: String
    var lastName: String
    var email: String
    var customerSince: String?
    var tax: String
    var gender: Int
    var status: Int
    var username: String
    var birthday: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, gender, status, uuid, birthday
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case customerSince = "customer_since"
        case tax = "tax_vat_number"
        case username = "user_name"
    }
}
