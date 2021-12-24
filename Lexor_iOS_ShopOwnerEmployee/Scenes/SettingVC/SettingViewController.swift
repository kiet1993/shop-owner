//
//  SettingViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 06/08/2021.
//

import UIKit

final class SettingViewController: BaseController {

    var viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction private func logoutButtonTouchUpInside(_ sender: Any) {
        callLogout()
    }

    private func callLogout() {
        HUD.show()
        viewModel.logout { [weak self] result in
            HUD.dismiss()
            guard let this = self else {return}
            switch result {
            case .success:
                AccountManager.shared.accessToken = nil
                AccountManager.shared.jwtToken = nil
                AppDelegate.shared.setRoot(type: .login)
            case .failure(let err):
                switch err._code {
                case 401, 403:
                    AccountManager.shared.accessToken = nil
                    AccountManager.shared.jwtToken = nil
                    AppDelegate.shared.setRoot(type: .login)
                default:
                    this.showNormalError(err)
                }
            }
        }
    }
}
