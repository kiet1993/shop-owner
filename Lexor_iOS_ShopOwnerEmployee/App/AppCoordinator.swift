//
//  AppCoordinator.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import CoreMotion

class AppCoordinator: Coordinator {
    let window: UIWindow?
    private(set) lazy var appTabbarController: AppTabbarController = {
        let tabbar = AppTabbarController(internetDeferer: internetDeferer)

        return tabbar
    }()
    let internetDeferer = InternetConnectionAvailableDeferer()
    let keychainManager = KeychainServiceManager()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
//        window?.rootViewController = ViewController()
        window?.rootViewController = appTabbarController
    }

    private func goToRegister() {
        
    }

    private func goToHome() {
        appTabbarController.appTabbarControllerDismissDelegate = self
        window?.rootViewController = appTabbarController
    }
}

// MARK: - AppTabbarControllerDismissDelegate
extension AppCoordinator: AppTabbarControllerDismissDelegate {
    func appTabbarController(_ tabbarController: AppTabbarController, didDismissVC viewcontroller: UIViewController?) {
        print("Dismissed: \(String(describing: viewcontroller?.classForCoder ?? nil))")
    }
}
