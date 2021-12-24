//
//  SettingViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 16/08/2021.
//

import Foundation

final class SettingViewModel {

    func logout(completion: @escaping APICompletion) {
        APIRequest.logout(token: AccountManager.shared.accessToken ?? "") { result in
            switch result {
            case .success:
                print("Haha")
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func unRegistFCMToken() {
        APIRequest.unRegisFCMToken { result in
            
        }
    }
    
}
