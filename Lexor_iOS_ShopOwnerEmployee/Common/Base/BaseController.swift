//
//  BaseController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/25/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit.UIViewController
import UIKit

enum LeftrNavigationItem: String {
    case back
    case none
}

class BaseController: UIViewController {
    
    deinit {
        print("✅ Deinit \(self.classForCoder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        barAppearance.titleTextAttributes = [.foregroundColor: UIColor.primaryPink]
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
    }
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomBackButton()
        handleHiddenNavigation(true, animated: animated)
    }

    // MARK: - Private functions

    func setupStatusBarBackgroundd() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height

            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.primaryPink
            view.addSubview(statusbarView)

            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true

        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.primaryPink
        }
    }
    
    func setCustomBackButton(
        iconBack: UIImage? = UIImage(named: "ic-back"),
        tintColor: UIColor? = .black
    ) {
        navigationItem.leftBarButtonItem = nil
        let newBackButton = UIBarButtonItem(image: iconBack?.withRenderingMode(.alwaysTemplate),
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleBack))
        newBackButton.tintColor = tintColor
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    func setTitle(text: String, color: UIColor) {
        title = text
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    func handleHiddenNavigation(_ hidden: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
}
