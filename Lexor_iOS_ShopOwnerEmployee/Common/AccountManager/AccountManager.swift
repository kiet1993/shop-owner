//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import JWTDecode

class AccountManager {
    
    let jwtTokenKey = "jwtTokenKey"
    let accessTokenKey = "accessTokenKey"
    static let isFirstLaunch = "isFirstLaunch"
    
    static let shared = AccountManager()

    private init() {}

    var currentUser: User?
    
    var jwtToken: String? {
        get {
            return UserDefaults.standard.string(forKey: jwtTokenKey)
        }
        set {
            if let token = newValue, !token.isEmpty {
                UserDefaults.standard.setValue(token, forKey: jwtTokenKey)
            } else {
                UserDefaults.standard.setValue(nil, forKey: jwtTokenKey)
            }
        }
    }
    
    private func decodeAccessTokenTogetUserInfo(_ token: String) {
        do {
            let jwt = try decode(jwt: token)
            let jsonData = try JSONSerialization.data(withJSONObject: jwt.body, options: [])
            let decoder = JSONDecoder()
            currentUser = try decoder.decode(User.self, from: jsonData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var accessToken: String? {
        get {
            if let token = UserDefaults.standard.string(forKey: accessTokenKey) {
                if currentUser == nil {
                    decodeAccessTokenTogetUserInfo(token)
                }
                return token
            }
            return nil
        }
        set {
            if let token = newValue, !token.isEmpty {
                decodeAccessTokenTogetUserInfo(token)
                UserDefaults.standard.setValue(token, forKey: accessTokenKey)
            } else {
                UserDefaults.standard.setValue(nil, forKey: accessTokenKey)
            }
        }
    }
    
    var shouldLogin: Bool {
        return accessToken.isNilOrEmpty
    }

    var cartID: Int?
    var cartUserToken: String?
    var fcmToken: String?
    var uuidRegistFCMToken: String?

    static var isFirst: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isFirstLaunch)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isFirstLaunch)
        }
    }

}
