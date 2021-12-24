//
//  Promotion.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 12/10/2021.
//

import UIKit

protocol PromotionType {
    var programName: String { get }
    var programCode: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var channelApplied: String { get }
    var applyTo: String { get }
    var creator: String { get }
    var createdAt: String { get }
    var updatedAt: String { get }
    var uuid: String { get }
    var status: Int { get }
    var discountCode: String { get }
    var discountType: String { get }
    var discountForm: String { get }
    var isOn: Bool { get }
    var isExpanded: Bool { get set }
}

struct Promotion: PromotionType, Codable {
    var createdAt: String
    var updatedAt: String
    var uuid: String
    var programCode: String
    var programName: String
    var channelApplied: String
    var status: Int
    var discountCode: String
    var discountType: String
    var discountForm: String
    var startDate: Date
    var endDate: Date
    var applyTo: String
    var creator: String
    var isOn: Bool {
        status == 1
    }
    var isExpanded = false
    
    enum CodingKeys: String, CodingKey {
        case uuid, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case programCode = "program_code"
        case programName = "program_name"
        case startDate = "from_date"
        case endDate = "to_date"
        case channelApplied = "channel_applied"
        case creator = "created_user"
        case applyTo = "apply_to"
        case discountCode = "discount_code"
        case discountType = "discount_type"
        case discountForm = "discount_form"
    }
}

struct ListPromotion: Codable {
    var limit: Int
    var page: Int
    var totalItems: Int
    var totalPages: Int
    var promotions: [Promotion]
    var isLoadmoreable: Bool {
        promotions.count < totalItems
    }
    
    enum CodingKeys: String, CodingKey {
        case limit, page
        case totalItems = "total_rows"
        case totalPages = "total_pages"
        case promotions = "rows"
    }
}

struct ListPromotionResponse: Codable {
    let status: Int
    var data: ListPromotion
}
