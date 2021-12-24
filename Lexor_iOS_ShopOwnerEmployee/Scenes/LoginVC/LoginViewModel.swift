//
//  LoginViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 23/05/2021.
//

import Foundation
import Network

struct LoginResult: Decodable {
    let token: String
}

final class LoginViewModel {
    
    var emailAddress: String = ""
    var password: String = ""
    var isValidEmailAddress: Bool = false
    var isValidPassword: Bool = false
    
    func validateEmpty() -> Bool {
        isValidEmailAddress = !emailAddress.isEmpty
        isValidPassword = !password.isEmpty
        return isValidEmailAddress && isValidPassword
    }


    func login(completion: @escaping APICompletion) {
        APIRequest.login(username: emailAddress, password: password) { [weak self] result in
            switch result {
            case .success(let value):
                AccountManager.shared.jwtToken = value.token
                self?.refreshToken(value.token, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func refreshToken(_ jwtToken: String, completion: @escaping APICompletion) {
        APIRequest.refreshToken(jwtToken) { [weak self] result in
            switch result {
            case .success(let value):
                AccountManager.shared.accessToken = value.token
                self?.registerFCMToken()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerFCMToken() {
        if let fcmToken = AccountManager.shared.fcmToken {
            APIRequest.regisFCMToken(fcmToken: fcmToken) { result in
                switch result {
                case .success(let registerResponse):
                    AccountManager.shared.uuidRegistFCMToken = registerResponse.uuid
                    print("Subcribe FCM token success!!!")
                case .failure(let error):
                    print("Subcribe FCM token failed with error \(error.localizedDescription)!!!")
                }
            }
        }
    }
}
