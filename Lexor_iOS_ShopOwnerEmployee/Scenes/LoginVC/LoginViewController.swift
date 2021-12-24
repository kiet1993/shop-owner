//
//  LoginViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 23/05/2021.
//

import UIKit
import AuthenticationServices

final class LoginViewController: BaseController {

    // MARK: - Outlet
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var loginButton: BaseButton!
    @IBOutlet weak private var forgotEmailPasswordButton: BaseButton!
    @IBOutlet weak private var signUpButton: BaseButton!
    @IBOutlet weak private var emailAddressView: UIView!
    @IBOutlet weak private var emailBadgeLabel: UILabel!
    @IBOutlet weak private var passwordBadgeLabel: UILabel!
    @IBOutlet weak private var passwordView: UIView!
    @IBOutlet weak private var errorEmailLabel: UILabel!
    @IBOutlet weak private var errorPasswordLabel: UILabel!
    
    // MARK: - Properties
    var viewModel = LoginViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private func
    private func changeStateLoginButton() {
        loginButton.isEnabled = viewModel.validateEmpty()
    }
    
    private func configView() {
        view.backgroundColor = .white
        loginButton.isEnabled = false
        loginButton.setBackgroundColor(color: UIColor(hexString: "fcada6"), state: .disabled)
        loginButton.setBackgroundColor(color: UIColor(hexString: "fc978b"), state: .normal)
        loginButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        loginButton.setTitleColor(.black, for: .normal)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Action
    @IBAction private func loginButtonTouchUpInside(_ sender: Any) {
        view.endEditing(true)
        login()
//        errorEmailLabel.isHidden = isValidEmail(email: viewModel.emailAddress)
//        errorPasswordLabel.isHidden = isValidPassword(password: viewModel.password)
//        if errorEmailLabel.isHidden {
//            AccountManager.isFirst = true
//            AppDelegate.shared.setRoot(type: .tabbar)
//        }
    }
    
    @IBAction private func forgotButtonTouchUpInside(_ sender: Any) {
    }
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func signupButtonTouchUpInside(_ sender: Any) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func login() {
        view.endEditing(true)
        HUD.show()
        viewModel.login { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                AppDelegate.shared.setRoot(type: .tabbar)
            case .failure(let error):
            this.showNormalError(error)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString = textField.text.content as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case emailTextField:
            viewModel.emailAddress = newText
        case passwordTextField:
            viewModel.password = newText
        default:
            break
        }
        changeStateLoginButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            view.endEditing(true)
        default:
            break
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            errorEmailLabel.isHidden = true
            emailTextField.placeholder = Config.emptyString
            emailAddressView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            emailAddressView.borderWidth = Config.borderWidth
            emailBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            emailBadgeLabel.isHidden = false
        case passwordTextField:
            errorPasswordLabel.isHidden = true
            passwordTextField.placeholder = Config.emptyString
            passwordView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            passwordView.borderWidth = Config.borderWidth
            passwordBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            passwordBadgeLabel.isHidden = false
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            if viewModel.emailAddress.isEmpty {
                emailTextField.placeholder = Config.emailAddressStr
                emailBadgeLabel.isHidden = true
                
            } else {
                emailBadgeLabel.isHidden = false
                emailTextField.placeholder = Config.emptyString
                emailBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            emailAddressView.borderColor = UIColor(hexString: Config.borderActiveColor)
        case passwordTextField:
            if viewModel.emailAddress.isEmpty {
                passwordTextField.placeholder = Config.passwordStr
                passwordBadgeLabel.isHidden = true
                
            } else {
                emailBadgeLabel.isHidden = false
                passwordTextField.placeholder = Config.emptyString
                passwordBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
                
            }
            passwordView.borderColor = UIColor(hexString: Config.borderActiveColor)
        default:
            break
        }
    }
}

// MARK: - Extension
extension LoginViewController {
    
    struct Config {
        static var borderActiveColor: String = "B1B1B1"
        static var emptyString: String = ""
        static var emailAddressStr: String = "User name"
        static var passwordStr: String = "Password"
        static var borderWidth: CGFloat = 1
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        return password.count > 6
    }
}
