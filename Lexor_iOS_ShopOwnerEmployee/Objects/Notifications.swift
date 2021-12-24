//
//  Notifications.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 10/10/2021.
//

import Foundation

// MARK: - Welcome
struct NotificationResponse: Decodable {
    let status: Int
    var data: NotificationClass
}

// MARK: - DataClass
struct NotificationClass: Decodable {
    let limit, page: Int
    let sort: String
    let totalRows, totalPages: Int
    var rows: [NotificationRow]

    enum CodingKeys: String, CodingKey {
        case limit, page, sort
        case totalRows = "total_rows"
        case totalPages = "total_pages"
        case rows
    }
}

// MARK: - Row
struct NotificationRow: Decodable {
    let createdAt, updatedAt: String
    var createdAtDate, updatedAtDate: Date?
    let uuid, userUUID: String
    let title, shortMessage, fullMessage: String
    let params: Params
    let imageLink: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uuid
        case userUUID = "user_uuid"
        case title
        case shortMessage = "short_message"
        case fullMessage = "full_message"
        case params
        case imageLink = "image_link"
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        createdAtDate = DateFormatter.notificationListDateFormater.date(from: createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        updatedAtDate = DateFormatter.notificationListDateFormater.date(from: updatedAt)
        userUUID = try container.decode(String.self, forKey: .userUUID)
        title = try container.decode(String.self, forKey: .title)
        shortMessage = try container.decode(String.self, forKey: .shortMessage)
        fullMessage = try container.decode(String.self, forKey: .fullMessage)
        imageLink = try container.decode(String.self, forKey: .imageLink)
        status = try container.decode(Int.self, forKey: .status)
        params = try container.decode(Params.self, forKey: .params)
    }
}

// MARK: - Params
struct Params: Decodable {
    let age: Int
    let name: String
}
