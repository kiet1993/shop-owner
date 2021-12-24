//
//  RegisterViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 22/05/2021.
//

import UIKit
import AuthenticationServices
import DropDown

final class RegisterViewController: BaseController {
    
    // MARK: - Outlet
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    @IBOutlet weak private var birthdayTextField: UITextField!
    @IBOutlet weak private var genderTextField: UITextField!
    @IBOutlet weak private var taxTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var streetAddress1TextField: UITextField!
    @IBOutlet weak private var streetAddress2TextField: UITextField!
    @IBOutlet weak private var countryTextField: UITextField!
    @IBOutlet weak private var cityTextField: UITextField!
    @IBOutlet weak private var stateTextField: UITextField!
    @IBOutlet weak private var zipCodeTextField: UITextField!
    @IBOutlet weak private var phoneTextField: UITextField!
    @IBOutlet weak private var faxTextField: UITextField!
    @IBOutlet weak private var websiteTextField: UITextField!
    @IBOutlet weak private var serviceWebsiteTextField: UITextField!
    
    @IBOutlet weak private var usernameBadgeLabel: UILabel!
    @IBOutlet weak private var firstNameBadgeLabel: UILabel!
    @IBOutlet weak private var lastNameBadgeLabel: UILabel!
    @IBOutlet weak private var birthdayBadgeLabel: UILabel!
    @IBOutlet weak private var genderBadgeLabel: UILabel!
    @IBOutlet weak private var taxBadgeLabel: UILabel!
    @IBOutlet weak private var emailBadgeLabel: UILabel!
    @IBOutlet weak private var passwordBadgeLabel: UILabel!
    @IBOutlet weak private var errorEmailLabel: UILabel!
    @IBOutlet weak private var errorPasswordLabel: UILabel!
    @IBOutlet weak private var streetAddress1BadgeLabel: UILabel!
    @IBOutlet weak private var streetAddress2BadgeLabel: UILabel!
    @IBOutlet weak private var countryBadgeLabel: UILabel!
    @IBOutlet weak private var cityBadgeLabel: UILabel!
    @IBOutlet weak private var stateBadgeLabel: UILabel!
    @IBOutlet weak private var zipCodeBadgeLabel: UILabel!
    @IBOutlet weak private var phoneBadgeLabel: UILabel!
    @IBOutlet weak private var faxBadgeLabel: UILabel!
    @IBOutlet weak private var websiteBadgeLabel: UILabel!
    @IBOutlet weak private var serviceWebsiteBadgeLabel: UILabel!
    @IBOutlet weak private var isDefaultBillingAddressLabel: UILabel!
    @IBOutlet weak private var isDefaultShippingAddressLabel: UILabel!
    @IBOutlet weak private var isBusinessClosedMovedLabel: UILabel!
    @IBOutlet weak private var isBusinessInsideMallAirPortLabel: UILabel!
    
    @IBOutlet weak private var iconCalendarImageView: UIImageView!
    @IBOutlet weak private var acceptButton: BaseButton!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var visableButton: UIButton!
    @IBOutlet weak private var isDefaultBillingAddressButton: UIButton!
    @IBOutlet weak private var isDefaultShippingAddressButton: UIButton!
    @IBOutlet weak private var isBusinessClosedMovedButton: UIButton!
    @IBOutlet weak private var isBusinessInsideMallAirPortButton: UIButton!
    
    @IBOutlet weak private var usernameView: UIView!
    @IBOutlet weak private var firstNameView: UIView!
    @IBOutlet weak private var lastNameView: UIView!
    @IBOutlet weak private var birthdayView: UIView!
    @IBOutlet weak private var genderView: UIView!
    @IBOutlet weak private var taxView: UIView!
    @IBOutlet weak private var emailAddressView: UIView!
    @IBOutlet weak private var passwordView: UIView!
    @IBOutlet weak private var streetAddress1View: UIView!
    @IBOutlet weak private var streetAddress2View: UIView!
    @IBOutlet weak private var countryView: UIView!
    @IBOutlet weak private var cityView: UIView!
    @IBOutlet weak private var stateView: UIView!
    @IBOutlet weak private var zipCodeView: UIView!
    @IBOutlet weak private var phoneView: UIView!
    @IBOutlet weak private var faxView: UIView!
    @IBOutlet weak private var websiteView: UIView!
    @IBOutlet weak private var serviceWebsiteView: UIView!
    
    // MARK: - Properties
    var viewModel = RegisterViewModel()
    private let datePicker = UIDatePicker()
    private let formatStringDate = "dd/MM/yyyy"
    private let dropDown = DropDown()
    private let imageCheck = UIImage(named: "ic-check-register")?.withRenderingMode(.alwaysOriginal)
    private let imageUnCheck = UIImage(named: "ic-uncheck-register")?.withRenderingMode(.alwaysOriginal)
    private var isDefaultBillingAddress: Bool = false {
        didSet {
            let image = isDefaultBillingAddress ? imageCheck : imageUnCheck
            isDefaultBillingAddressButton.setImage(image, for: .normal)
            viewModel.isDefaultBillingAddress = isDefaultBillingAddress
        }
    }
    private var isDefaultShippingAddress: Bool = false {
        didSet {
            let image = isDefaultShippingAddress ? imageCheck : imageUnCheck
            isDefaultShippingAddressButton.setImage(image, for: .normal)
            viewModel.isDefaultShippingAddress = isDefaultShippingAddress
        }
    }
    private var isBusinessClosedAndMoved: Bool = false {
        didSet {
            let image = isBusinessClosedAndMoved ? imageCheck : imageUnCheck
            isBusinessClosedMovedButton.setImage(image, for: .normal)
            viewModel.isBusinessClosedMoved = isBusinessClosedAndMoved
        }
    }
    private var isBusinessInsideMallAirPort: Bool = false {
        didSet {
            let image = isBusinessInsideMallAirPort ? imageCheck : imageUnCheck
            isBusinessInsideMallAirPortButton.setImage(image, for: .normal)
            viewModel.isBusinessInsideMallAirport = isBusinessInsideMallAirPort
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configNotificationKeyboard()
        createDatePicker()
        binding()
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Private func
    private func configView() {
        // Color
        acceptButton.isEnabled = false
        acceptButton.setBackgroundColor(color: UIColor(hexString: "fcada6"), state: .disabled)
        acceptButton.setBackgroundColor(color: UIColor(hexString: "fc978b"), state: .normal)
        acceptButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        acceptButton.setTitleColor(.black, for: .normal)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        birthdayTextField.delegate = self
        emailTextField.delegate = self
        taxTextField.delegate = self
        streetAddress1TextField.delegate = self
        streetAddress2TextField.delegate = self
        countryTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        phoneTextField.delegate = self
        faxTextField.delegate = self
        websiteTextField.delegate = self
        serviceWebsiteTextField.delegate = self
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        iconCalendarImageView.image = UIImage(named: "ic-calendar")?.withRenderingMode(.alwaysTemplate)
        iconCalendarImageView.tintColor = .black
        dropDown.anchorView = genderView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["Male", "Female"]
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.genderTextField.text = item
            self?.viewModel.gender = item
            self?.changeStateLoginButton()
        }
        
        isDefaultBillingAddress = false
        isDefaultShippingAddress = false
        isBusinessClosedAndMoved = false
        isBusinessInsideMallAirPort = false
        
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        
        scrollView.keyboardDismissMode = .interactive
        scrollView.addTapGesture(target: self, action: #selector(hideKeyboard))
        
        viewModel.delegate = self
    }
    
    private func changeStateLoginButton() {
        acceptButton.isEnabled = viewModel.validateEmpty()
    }
    
    private func isValidEmailOrPassword() -> Bool {
        errorEmailLabel.isHidden = viewModel.emailAddress.isValidEmail()
        errorPasswordLabel.isHidden = isValidPassword(password: viewModel.password)
        return viewModel.emailAddress.isValidEmail() || isValidPassword(password: viewModel.password)
    }
    
    private func configNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func binding() {
        viewModel.loading = { [weak self] isLoading in
            isLoading ? HUD.show() : HUD.dismiss()
            self?.view.isUserInteractionEnabled = isLoading ? false : true
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if scrollView.contentInset.bottom < userInfo.height {
                let bottomSafeArea = additionalSafeAreaInsets.bottom
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: userInfo.height - (bottomSafeArea + 115), right: 0.0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if let userInfo = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomSafeArea = additionalSafeAreaInsets.bottom
            if scrollView.contentInset.bottom >= userInfo.height - (bottomSafeArea + 115) {
                let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                scrollView.scrollRectToVisible(CGRect.zero, animated: true)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            }
        }
    }
    
    @objc private  func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStringDate
        viewModel.birthday = datePicker.date
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        birthdayTextField.endEditing(true)
        changeStateLoginButton()
    }
    
    private func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    // MARK: - Action
    @IBAction private func acceptButtonTouchUpInside(_ sender: Any) {
        view.endEditing(true)
        if isValidEmailOrPassword() {
            viewModel.registerBusinessAccount()
        }
    }
    
    @IBAction private func loginButtonTouchUpInside(_ sender: Any) {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction private func visableButtonTouchUpInside(_ sender: Any) {
        if !visableButton.isSelected {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        visableButton.isSelected = !visableButton.isSelected
    }
    
    @IBAction func didTapShowGender(_ sender: Any) {
        view.endEditing(true)
        dropDown.show()
    }
    
    @IBAction func didTapIsDefaultBillingAddress(_ sender: Any) {
        isDefaultBillingAddress.toggle()
    }
    
    @IBAction func didTapIsDefaultShippingAddress(_ sender: Any) {
        isDefaultShippingAddress.toggle()
    }
    
    @IBAction func didTapIsBusinessClosedMoved(_ sender: Any) {
        isBusinessClosedAndMoved.toggle()
    }
    
    @IBAction func didTapIsBusinessInsideMallAirPort(_ sender: Any) {
        isBusinessInsideMallAirPort.toggle()
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString = textField.text.content as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case usernameTextField:
            viewModel.username = newText
        case passwordTextField:
            viewModel.password = newText
        case firstNameTextField:
            viewModel.firstName = newText
        case lastNameTextField:
            viewModel.lastName = newText
        case emailTextField:
            viewModel.emailAddress = newText
        case taxTextField:
            viewModel.taxNumber = newText
        case streetAddress1TextField:
            viewModel.streetAddress1 = newText
        case streetAddress2TextField:
            viewModel.streetAddress2 = newText
        case countryTextField:
            viewModel.country = newText
        case cityTextField:
            viewModel.city = newText
        case stateTextField:
            viewModel.state = newText
        case zipCodeTextField:
            viewModel.zipcode = newText
        case phoneTextField:
            viewModel.phone = newText
        case faxTextField:
            viewModel.fax = newText
        case websiteTextField:
            viewModel.website = newText
        case serviceWebsiteTextField:
            viewModel.serviceWebsite = newText
        default:
            break
        }
        changeStateLoginButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            firstNameTextField.becomeFirstResponder()
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            birthdayTextField.becomeFirstResponder()
        case birthdayTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            taxTextField.becomeFirstResponder()
        case taxTextField:
            streetAddress1TextField.becomeFirstResponder()
        case streetAddress1TextField:
            streetAddress2TextField.becomeFirstResponder()
        case streetAddress2TextField:
            countryTextField.becomeFirstResponder()
        case countryTextField:
            cityTextField.becomeFirstResponder()
        case cityTextField:
            stateTextField.becomeFirstResponder()
        case stateTextField:
            zipCodeTextField.becomeFirstResponder()
        case zipCodeTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            faxTextField.becomeFirstResponder()
        case faxTextField:
            websiteTextField.becomeFirstResponder()
        case websiteTextField:
            serviceWebsiteTextField.becomeFirstResponder()
        case serviceWebsiteTextField:
            view.endEditing(true)
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            usernameTextField.placeholder = Config.emptyString
            usernameView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            usernameView.borderWidth = Config.borderWidth
            usernameBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            usernameBadgeLabel.isHidden = false
        case passwordTextField:
            errorPasswordLabel.isHidden = true
            passwordTextField.placeholder = Config.emptyString
            passwordView.borderWidth = Config.borderWidth
            passwordView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            passwordBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            passwordBadgeLabel.isHidden = false
        case firstNameTextField:
            firstNameTextField.placeholder = Config.emptyString
            firstNameView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            firstNameView.borderWidth = Config.borderWidth
            firstNameBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            firstNameBadgeLabel.isHidden = false
        case lastNameTextField:
            lastNameTextField.placeholder = Config.emptyString
            lastNameView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            lastNameView.borderWidth = Config.borderWidth
            lastNameBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            lastNameBadgeLabel.isHidden = false
        case emailTextField:
            errorEmailLabel.isHidden = true
            emailTextField.placeholder = Config.emptyString
            emailAddressView.borderWidth = Config.borderWidth
            emailAddressView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            emailBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            emailBadgeLabel.isHidden = false
        case birthdayTextField:
            birthdayTextField.placeholder = Config.emptyString
            birthdayView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            birthdayView.borderWidth = Config.borderWidth
            birthdayBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            birthdayBadgeLabel.isHidden = false
        case emailTextField:
            emailTextField.placeholder = Config.emptyString
            emailAddressView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            emailAddressView.borderWidth = Config.borderWidth
            emailBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            emailBadgeLabel.isHidden = false
        case taxTextField:
            taxTextField.placeholder = Config.emptyString
            taxView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            taxView.borderWidth = Config.borderWidth
            taxBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            taxBadgeLabel.isHidden = false
        case streetAddress1TextField:
            streetAddress1TextField.placeholder = Config.emptyString
            streetAddress1View.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            streetAddress1View.borderWidth = Config.borderWidth
            streetAddress1BadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            streetAddress1BadgeLabel.isHidden = false
        case streetAddress2TextField:
            streetAddress2TextField.placeholder = Config.emptyString
            streetAddress2View.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            streetAddress2View.borderWidth = Config.borderWidth
            streetAddress2BadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            streetAddress2BadgeLabel.isHidden = false
        case countryTextField:
            countryTextField.placeholder = Config.emptyString
            countryView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            countryView.borderWidth = Config.borderWidth
            countryBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            countryBadgeLabel.isHidden = false
        case cityTextField:
            cityTextField.placeholder = Config.emptyString
            cityView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            cityView.borderWidth = Config.borderWidth
            cityBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            cityBadgeLabel.isHidden = false
        case stateTextField:
            stateTextField.placeholder = Config.emptyString
            stateView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            stateView.borderWidth = Config.borderWidth
            stateBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            stateBadgeLabel.isHidden = false
        case zipCodeTextField:
            zipCodeTextField.placeholder = Config.emptyString
            zipCodeView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            zipCodeView.borderWidth = Config.borderWidth
            zipCodeBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            zipCodeBadgeLabel.isHidden = false
        case phoneTextField:
            phoneTextField.placeholder = Config.emptyString
            phoneView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            phoneView.borderWidth = Config.borderWidth
            phoneBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            phoneBadgeLabel.isHidden = false
        case faxTextField:
            faxTextField.placeholder = Config.emptyString
            faxView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            faxView.borderWidth = Config.borderWidth
            faxBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            faxBadgeLabel.isHidden = false
        case websiteTextField:
            websiteTextField.placeholder = Config.emptyString
            websiteView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            websiteView.borderWidth = Config.borderWidth
            websiteBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            websiteBadgeLabel.isHidden = false
        case serviceWebsiteTextField:
            serviceWebsiteTextField.placeholder = Config.emptyString
            serviceWebsiteView.borderColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            serviceWebsiteView.borderWidth = Config.borderWidth
            serviceWebsiteBadgeLabel.textColor = #colorLiteral(red: 0, green: 0.723800838, blue: 0.471662581, alpha: 1)
            serviceWebsiteBadgeLabel.isHidden = false
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            
        case usernameTextField:
            if viewModel.username.isEmpty {
                usernameTextField.placeholder = Config.usernameStr
                usernameBadgeLabel.isHidden = true
            } else {
                usernameBadgeLabel.isHidden = false
                usernameTextField.placeholder = Config.emptyString
                usernameBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            usernameView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case passwordTextField:
            if viewModel.password.isEmpty {
                passwordBadgeLabel.isHidden = true
                passwordTextField.placeholder = Config.passwordStr
            } else {
                passwordTextField.placeholder = Config.emptyString
                passwordBadgeLabel.isHidden = false
                passwordBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            passwordView.borderColor = UIColor(hexString: Config.borderActiveColor)
        
        case firstNameTextField:
            if viewModel.firstName.isEmpty {
                firstNameTextField.placeholder = Config.firstNameStr
                firstNameBadgeLabel.isHidden = true
                
            } else {
                firstNameBadgeLabel.isHidden = false
                firstNameTextField.placeholder = ""
                firstNameBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            firstNameView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case lastNameTextField:
            
            if viewModel.lastName.isEmpty {
                lastNameTextField.placeholder = Config.lastNameStr
                lastNameBadgeLabel.isHidden = true
            } else {
                lastNameBadgeLabel.isHidden = false
                lastNameTextField.placeholder = Config.emptyString
                lastNameBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            lastNameView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case birthdayTextField:
            birthdayBadgeLabel.isHidden = false
            birthdayBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            birthdayView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
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
            
        case taxTextField:
            if viewModel.taxNumber.isEmpty {
                taxBadgeLabel.isHidden = true
                taxTextField.placeholder = Config.taxStr
            } else {
                taxTextField.placeholder = Config.emptyString
                taxBadgeLabel.isHidden = false
                taxBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            taxView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case streetAddress1TextField:
            if viewModel.streetAddress1.isEmpty {
                streetAddress1BadgeLabel.isHidden = true
                streetAddress1TextField.placeholder = Config.streetAddress1Str
            } else {
                streetAddress1TextField.placeholder = Config.emptyString
                streetAddress1BadgeLabel.isHidden = false
                streetAddress1BadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            streetAddress1View.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case streetAddress2TextField:
            if viewModel.streetAddress2.isEmpty {
                streetAddress2TextField.placeholder = Config.streetAddress2Str
                streetAddress2BadgeLabel.isHidden = true
            } else {
                streetAddress2TextField.placeholder = Config.emptyString
                streetAddress2BadgeLabel.isHidden = false
                streetAddress2BadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            streetAddress2View.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case countryTextField:
            if viewModel.country.isEmpty {
                countryTextField.placeholder = Config.countryStr
                countryBadgeLabel.isHidden = true
            } else {
                countryTextField.placeholder = Config.emptyString
                countryBadgeLabel.isHidden = false
                countryBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            countryView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case cityTextField:
            if viewModel.city.isEmpty {
                cityTextField.placeholder = Config.cityStr
                cityBadgeLabel.isHidden = true
            } else {
                cityTextField.placeholder = Config.emptyString
                cityBadgeLabel.isHidden = false
                cityBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            cityView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case stateTextField:
            if viewModel.state.isEmpty {
                stateBadgeLabel.isHidden = true
                stateTextField.placeholder = Config.stateStr
            } else {
                stateTextField.placeholder = Config.emptyString
                stateBadgeLabel.isHidden = false
                stateBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            stateView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case zipCodeTextField:
            if viewModel.zipcode.isEmpty {
                zipCodeBadgeLabel.isHidden = true
                zipCodeTextField.placeholder = Config.zipCodeStr
            } else {
                zipCodeTextField.placeholder = Config.emptyString
                zipCodeBadgeLabel.isHidden = false
                zipCodeBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            zipCodeView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case phoneTextField:
            if viewModel.phone.isEmpty {
                phoneTextField.placeholder = Config.phoneStr
                phoneBadgeLabel.isHidden = true
            } else {
                phoneTextField.placeholder = Config.emptyString
                phoneBadgeLabel.isHidden = false
                phoneBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            phoneView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case faxTextField:
            if viewModel.fax.isEmpty {
                faxTextField.placeholder = Config.faxStr
                faxBadgeLabel.isHidden = true
            } else {
                faxTextField.placeholder = Config.emptyString
                faxBadgeLabel.isHidden = false
                faxBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            faxView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case websiteTextField:
            if viewModel.website.isEmpty {
                websiteTextField.placeholder = Config.websiteStr
                websiteBadgeLabel.isHidden = true
            } else {
                websiteTextField.placeholder = Config.emptyString
                websiteBadgeLabel.isHidden = false
                websiteBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            websiteView.borderColor = UIColor(hexString: Config.borderActiveColor)
            
        case serviceWebsiteTextField:
            if viewModel.serviceWebsite.isEmpty {
                serviceWebsiteTextField.placeholder = Config.serviceWebsiteStr
                serviceWebsiteBadgeLabel.isHidden = true
            } else {
                serviceWebsiteTextField.placeholder = Config.emptyString
                serviceWebsiteBadgeLabel.isHidden = false
                serviceWebsiteBadgeLabel.textColor = UIColor(hexString: Config.borderActiveColor)
            }
            serviceWebsiteView.borderColor = UIColor(hexString: Config.borderActiveColor)
        
        default:
            break
        }
    }
}

extension RegisterViewController {
    
    struct Config {
        static var borderActiveColor: String = "B1B1B1"
        static var emptyString: String = ""
        static var usernameStr = "User name"
        static var passwordStr: String = "Password"
        static var firstNameStr: String = "First name"
        static var lastNameStr: String = "Last name"
        static var emailAddressStr: String = "Email"
        static var taxStr = "Tax number"
        static var streetAddress1Str = "Street address 1"
        static var streetAddress2Str = "Street address 2"
        static var countryStr = "Country"
        static var cityStr = "City"
        static var stateStr = "State"
        static var zipCodeStr = "Zip Code"
        static var phoneStr = "Phone"
        static var faxStr = "Fax"
        static var websiteStr = "https://"
        static var serviceWebsiteStr = "https://"
        static var borderWidth: CGFloat = 1
    }
    
    func isValidPassword(password: String) -> Bool {
        return password.count > 6
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func didRegisterFailed(error: Error) {
        showNormalError(error, actionHandler: nil, completionHandler: nil)
    }
    
    func didRegisterSuccess() {
        showAlert(message: "Thank you for register new business account, we will contact you soon.", handler:  { [weak self] in
            self?.navigationController?.popToRootViewController(animated: false)
        })
    }
}
