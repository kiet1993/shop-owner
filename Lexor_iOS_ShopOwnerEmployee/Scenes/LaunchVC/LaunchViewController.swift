//
//  LaunchViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 24/05/2021.
//

import UIKit

final class LaunchViewController: BaseController {
    
    // MARK: - Outlet
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet weak private var loginAccountButton: BaseButton!
    @IBOutlet weak private var createAccountButton: BaseButton!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        configTextView()
    }
    
    // MARK: - Private func
    private func configTextView() {
        let attributedString = NSMutableAttributedString(string: Config.textViewStr)
        let url = URL(string: "https://www.apple.com")!
        let url2 = URL(string: "https://www.google.com")!
        // Set the 'click here' substring to be the link
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:35,length:17))
        attributedString.setAttributes([.link: url], range: NSMakeRange(36, 16))
        attributedString.setAttributes([.link: url2], range: NSMakeRange(77, 14))
        textView.attributedText = attributedString
        textView.textAlignment = .center
        textView.isUserInteractionEnabled = true
        textView.isEditable = false

        // Set how links should appear: blue and underlined
        textView.linkTextAttributes = [
            .foregroundColor: UIColor(hexString: "467780")
        ]
    }

    // MARK: - Action
    @IBAction private func createAccountButtonTouchUpInside(_ sender: Any) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func loginAccountButtonTouchUpInside(_ sender: Any) {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension LaunchViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.canOpenURL(URL)
    }
}

// MARK: - Extension
extension LaunchViewController {
    struct Config {
        static var textViewStr: String = "By continuing, you agree to Lexor's Terms of Service and acknowledge Lexor's Pricacy Policy. You also understand that Lexor may send maketing emails abou Lexer's product, and local event. You can unsubscribe at any time"
    }
}
