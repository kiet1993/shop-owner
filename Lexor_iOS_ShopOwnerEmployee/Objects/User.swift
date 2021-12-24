//
//  User.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 06/05/2021.
//

import UIKit

struct User: Codable {
    var username: String
    var userid: String
    var usertypeString: String
    var tenantId: String
    var exp: Double
    
    var userType : UserType {
        return UserType(rawValue: usertypeString) ?? .shopOwner
    }
    
    enum CodingKeys: String, CodingKey {
        case username,
             userid,
             tenantId,
             exp
        case usertypeString = "usertype"
    }
    
    enum UserType: String {
        case shopOwner = "business"
        case technician = "specialist"
    }
}
