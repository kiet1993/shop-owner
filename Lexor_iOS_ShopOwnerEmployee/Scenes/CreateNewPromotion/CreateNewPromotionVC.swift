//
//  CreateNewPromotionVC.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 18/10/2021.
//

import UIKit
import TagListView
import DropDown

class CreateNewPromotionVC: BaseController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var promotionNameTextField: UITextField!
    @IBOutlet weak var promotionCodeTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var applyToChannelOnlineButton: UIButton!
    @IBOutlet weak var applyToChannelOfflineButton: UIButton!
    @IBOutlet weak var applyToTextField: UITextField!
    @IBOutlet weak var addApplyToButton: UIButton!
    @IBOutlet weak var applyToContentView: TagListView!
    @IBOutlet weak var creatorTextField: UITextField!
    @IBOutlet weak var discountTypeTextField: UITextField!
    @IBOutlet weak var discountFormPercentButton: UIButton!
    @IBOutlet weak var valueDiscountPercentTextField: UITextField!
    @IBOutlet weak var discountFormNumberMoneyButton: UIButton!
    @IBOutlet weak var valueDiscountNumberMoneyTextField: UITextField!
    @IBOutlet weak var maxDiscountAmountTextField: UITextField!
    @IBOutlet weak var numberOfGiftCodeTextField: UITextField!
    @IBOutlet weak var discountCodeTextField: UITextField!
    @IBOutlet weak var applyForAllServicesButton: UIButton!
    @IBOutlet weak var applyForSpecificServiceButton: UIButton!
    @IBOutlet weak var specificServiceTextField: UITextField!
    @IBOutlet weak var addSpecificServiceButton: UIButton!
    @IBOutlet weak var specificServiceContentView: TagListView!
    @IBOutlet weak var setToActiveButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var unitPercentDiscountLabel: UILabel!
    @IBOutlet weak var unitUSDDiscountLabel: UILabel!
    @IBOutlet weak var titleAllServiceLabel: UILabel!
    @IBOutlet weak var titleSelectServiceLabel: UILabel!
    @IBOutlet weak var selectServiceButton: UIButton!
    
    var viewModel: CreateNewPromotionViewModelType?
    private let datePickerStartDate = UIDatePicker()
    private let datePickerEndDate = UIDatePicker()
    private let formatStringDate = "dd/MM/yyyy"
    private let dropDownCreator = DropDown()
    private let dropDownService = DropDown()
    private let dropDownApplyTo = DropDown()
    private let dropDownDiscountType = DropDown()
    private var isSelectOnline = false {
        didSet {
            applyToChannelOnlineButton.setImage(UIImage(named: isSelectOnline ? "ic-check-register" : "ic-uncheck-register"), for: .normal)
        }
    }
    private var isSelectOffline = false {
        didSet {
            applyToChannelOfflineButton.setImage(UIImage(named: isSelectOffline ? "ic-check-register" : "ic-uncheck-register"), for: .normal)
        }
    }
    private var isSelectDiscountPercent = false {
        didSet {
            discountFormPercentButton.setImage(UIImage(named: isSelectDiscountPercent ? "ic-selected" : "ic-unselected"), for: .normal)
            unitPercentDiscountLabel.alpha = isSelectDiscountPercent ? 1.0 : 0.5
            valueDiscountPercentTextField.alpha = isSelectDiscountPercent ? 1.0 : 0.5
            valueDiscountPercentTextField.isUserInteractionEnabled = isSelectDiscountPercent
        }
    }
    private var isSelectDiscountNumber = false {
        didSet {
            discountFormNumberMoneyButton.setImage(UIImage(named: isSelectDiscountNumber ? "ic-selected" : "ic-unselected"), for: .normal)
            unitUSDDiscountLabel.alpha = isSelectDiscountNumber ? 1.0 : 0.5
            valueDiscountNumberMoneyTextField.alpha = isSelectDiscountNumber ? 1.0 : 0.5
            valueDiscountNumberMoneyTextField.isUserInteractionEnabled = isSelectDiscountNumber
        }
    }
    private var isSelectAllServices = false {
        didSet {
            applyForAllServicesButton.setImage(UIImage(named: isSelectAllServices ? "ic-selected" : "ic-unselected"), for: .normal)
            titleAllServiceLabel.alpha = isSelectAllServices ? 1.0 : 0.5
        }
    }
    private var isSelectService = false {
        didSet {
            applyForSpecificServiceButton.setImage(UIImage(named: isSelectService ? "ic-selected" : "ic-unselected"), for: .normal)
            titleSelectServiceLabel.alpha = isSelectService ? 1.0 : 0.5
            specificServiceTextField.alpha = isSelectService ? 1.0 : 0.5
            addSpecificServiceButton.alpha = isSelectService ? 1.0 : 0.5
            selectServiceButton.isUserInteractionEnabled = isSelectService
            addSpecificServiceButton.isUserInteractionEnabled = isSelectService
            specificServiceTextField.isUserInteractionEnabled = isSelectService
        }
    }
    private var isSelectSetToActive = false {
        didSet {
            setToActiveButton.setImage(UIImage(named: isSelectSetToActive ? "ic-check-register" : "ic-uncheck-register"), for: .normal)
        }
    }
    
    init (createNewPromotionViewModel: CreateNewPromotionViewModelType) {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        self.viewModel = createNewPromotionViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configNotificationKeyboard()
        createDatePickerStartDate()
        createDatePickerEndDate()
        setupTagListView()
        setupDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHiddenNavigation(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setupUI() {
        setTitle(text: "Add new Promotion", color: UIColor(hexString: "EE9C8F"))
        view.backgroundColor = .white
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.isEnabled = false
        saveButton.setBackgroundColor(color: UIColor(hexString: "fcada6"), state: .disabled)
        saveButton.setBackgroundColor(color: UIColor(hexString: "fc978b"), state: .normal)
        saveButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        saveButton.setTitleColor(.black, for: .normal)
        
        promotionNameTextField.delegate = self
        promotionNameTextField.borderWidth = 1.0
        promotionNameTextField.borderColor = UIColor(hexString: "B1B1B1")
        promotionNameTextField.layer.cornerRadius = 4.0
        promotionNameTextField.setUpTextFieldInput(placeholder: "Promotion Name")
        
        promotionCodeTextField.delegate = self
        promotionCodeTextField.borderWidth = 1.0
        promotionCodeTextField.borderColor = UIColor(hexString: "B1B1B1")
        promotionCodeTextField.layer.cornerRadius = 4.0
        promotionCodeTextField.setUpTextFieldInput(placeholder: "Promotion Code")
        
        startDateTextField.delegate = self
        startDateTextField.borderWidth = 1.0
        startDateTextField.borderColor = UIColor(hexString: "B1B1B1")
        startDateTextField.layer.cornerRadius = 4.0
        startDateTextField.setUpTextFieldInput(placeholder: "dd/MM/yyyy")
        
        endDateTextField.delegate = self
        endDateTextField.borderWidth = 1.0
        endDateTextField.borderColor = UIColor(hexString: "B1B1B1")
        endDateTextField.layer.cornerRadius = 4.0
        endDateTextField.setUpTextFieldInput(placeholder: "dd/MM/yyyy")
        
        applyToTextField.delegate = self
        applyToTextField.borderWidth = 1.0
        applyToTextField.borderColor = UIColor(hexString: "B1B1B1")
        applyToTextField.layer.cornerRadius = 4.0
        applyToTextField.setUpTextFieldInput(placeholder: "Apply to", widthRightView: 32)
        
        creatorTextField.delegate = self
        creatorTextField.borderWidth = 1.0
        creatorTextField.borderColor = UIColor(hexString: "B1B1B1")
        creatorTextField.layer.cornerRadius = 4.0
        creatorTextField.setUpTextFieldInput(placeholder: "Creator", widthRightView: 32)
        
        discountTypeTextField.delegate = self
        discountTypeTextField.borderWidth = 1.0
        discountTypeTextField.borderColor = UIColor(hexString: "B1B1B1")
        discountTypeTextField.layer.cornerRadius = 4.0
        discountTypeTextField.setUpTextFieldInput(placeholder: "Discount Type")
        
        valueDiscountPercentTextField.delegate = self
        valueDiscountPercentTextField.borderWidth = 1.0
        valueDiscountPercentTextField.borderColor = UIColor(hexString: "B1B1B1")
        valueDiscountPercentTextField.layer.cornerRadius = 4.0
        valueDiscountPercentTextField.setUpTextFieldInput(placeholder: "")
        
        valueDiscountNumberMoneyTextField.delegate = self
        valueDiscountNumberMoneyTextField.borderWidth = 1.0
        valueDiscountNumberMoneyTextField.borderColor = UIColor(hexString: "B1B1B1")
        valueDiscountNumberMoneyTextField.layer.cornerRadius = 4.0
        valueDiscountNumberMoneyTextField.setUpTextFieldInput(placeholder: "")
        
        maxDiscountAmountTextField.delegate = self
        maxDiscountAmountTextField.borderWidth = 1.0
        maxDiscountAmountTextField.borderColor = UIColor(hexString: "B1B1B1")
        maxDiscountAmountTextField.layer.cornerRadius = 4.0
        maxDiscountAmountTextField.setUpTextFieldInput(placeholder: "")
        
        numberOfGiftCodeTextField.delegate = self
        numberOfGiftCodeTextField.borderWidth = 1.0
        numberOfGiftCodeTextField.borderColor = UIColor(hexString: "B1B1B1")
        numberOfGiftCodeTextField.layer.cornerRadius = 4.0
        numberOfGiftCodeTextField.setUpTextFieldInput(placeholder: "Gift code")
        
        discountCodeTextField.delegate = self
        discountCodeTextField.borderWidth = 1.0
        discountCodeTextField.borderColor = UIColor(hexString: "B1B1B1")
        discountCodeTextField.layer.cornerRadius = 4.0
        discountCodeTextField.setUpTextFieldInput(placeholder: "Discount Code")
        
        specificServiceTextField.delegate = self
        specificServiceTextField.borderWidth = 1.0
        specificServiceTextField.borderColor = UIColor(hexString: "B1B1B1")
        specificServiceTextField.layer.cornerRadius = 4.0
        specificServiceTextField.setUpTextFieldInput(placeholder: "Service", widthRightView: 32)
        
        datePickerStartDate.minimumDate = Date()
        datePickerStartDate.datePickerMode = .date

        datePickerEndDate.minimumDate = Date()
        datePickerEndDate.datePickerMode = .date
        
        scrollView.keyboardDismissMode = .interactive
        scrollView.addTapGesture(target: self, action: #selector(hideKeyboard))
        
        isSelectOnline = false
        isSelectOffline = false
        isSelectDiscountPercent = true
        isSelectDiscountNumber = false
        isSelectAllServices = true
        isSelectService = false
        isSelectSetToActive = true
        
        applyToContentView.isHidden = true
        specificServiceContentView.isHidden = true
    }
    
    private func configNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTagListView() {
        applyToContentView.textFont = .systemFont(ofSize: 13, weight: .medium)
        applyToContentView.textColor = .white
        applyToContentView.enableRemoveButton = true
        applyToContentView.tagBackgroundColor = .primaryPink
        applyToContentView.removeIconLineColor = .white
        applyToContentView.paddingX = 10
        applyToContentView.paddingY = 10
        applyToContentView.marginX = 8
        applyToContentView.marginY = 8
        applyToContentView.delegate = self
        
        specificServiceContentView.textFont = .systemFont(ofSize: 13, weight: .medium)
        specificServiceContentView.textColor = .white
        specificServiceContentView.enableRemoveButton = true
        specificServiceContentView.tagBackgroundColor = .primaryPink
        specificServiceContentView.removeIconLineColor = .white
        specificServiceContentView.paddingX = 10
        specificServiceContentView.paddingY = 10
        specificServiceContentView.marginX = 8
        specificServiceContentView.marginY = 8
        specificServiceContentView.delegate = self
    }
    
    private func setupDropDown() {
        dropDownService.anchorView = specificServiceTextField
        dropDownService.bottomOffset = CGPoint(x: 0, y:(dropDownService.anchorView?.plainView.bounds.height)!)
        dropDownService.dataSource = ["Service1", "Service2", "Service3"]
        dropDownService.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDownService.deselectRow(index)
            self?.dropDownService.reloadAllComponents()
            self?.specificServiceTextField.text = item
        }
        
        dropDownCreator.anchorView = creatorTextField
        dropDownCreator.bottomOffset = CGPoint(x: 0, y:(dropDownCreator.anchorView?.plainView.bounds.height)!)
        dropDownCreator.dataSource = ["Ronaldo", "Messi", "Henry"]
        dropDownCreator.selectionAction = { [weak self] (index: Int, item: String) in
            self?.creatorTextField.text = item
        }
        
        dropDownApplyTo.anchorView = applyToTextField
        dropDownApplyTo.bottomOffset = CGPoint(x: 0, y:(dropDownApplyTo.anchorView?.plainView.bounds.height)!)
        dropDownApplyTo.dataSource = ["Environment1", "Environment2", "Environment3"]
        dropDownApplyTo.selectionAction = { [weak self] (index: Int, item: String) in
            self?.dropDownApplyTo.deselectRow(index)
            self?.dropDownApplyTo.reloadAllComponents()
            self?.applyToTextField.text = item
        }
        
        dropDownDiscountType.anchorView = discountTypeTextField
        dropDownDiscountType.bottomOffset = CGPoint(x: 0, y:(dropDownDiscountType.anchorView?.plainView.bounds.height)!)
        dropDownDiscountType.dataSource = ["Total orders", "Each order", "Voucher"]
        dropDownDiscountType.selectionAction = { [weak self] (index: Int, item: String) in
            self?.discountTypeTextField.text = item
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
    
    @objc private  func donePressedStartDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStringDate
        startDateTextField.text = dateFormatter.string(from: datePickerStartDate.date)
        startDateTextField.endEditing(true)
        datePickerEndDate.minimumDate = datePickerStartDate.date
    }
    
    @objc private  func donePressedEndDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatStringDate
        endDateTextField.text = dateFormatter.string(from: datePickerEndDate.date)
        endDateTextField.endEditing(true)
    }
    
    private func createDatePickerStartDate() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStartDate))
        toolbar.setItems([doneButton], animated: true)
        
        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = datePickerStartDate
    }
    
    private func createDatePickerEndDate() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEndDate))
        toolbar.setItems([doneButton], animated: true)
        
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = datePickerEndDate
    }
    
    private func checkApplyToTagDisplay() {
        applyToContentView.isHidden = applyToContentView.tagViews.isEmpty
    }
    
    private func checkSpecificServiceTagDisplay() {
        specificServiceContentView.isHidden = specificServiceContentView.tagViews.isEmpty
    }
    
    @IBAction func didTapApplyToChannelOnline(_ sender: Any) {
        isSelectOnline.toggle()
    }
    
    @IBAction func didTapApplyToChannelOffline(_ sender: Any) {
        isSelectOffline.toggle()
    }
    
    @IBAction func didTapDiscountPercent(_ sender: Any) {
        if isSelectDiscountPercent {
            return
        }
        isSelectDiscountPercent.toggle()
        isSelectDiscountNumber.toggle()
        hideKeyboard()
    }
    
    @IBAction func didTapDiscountNumber(_ sender: Any) {
        if isSelectDiscountNumber {
            return
        }
        isSelectDiscountNumber.toggle()
        isSelectDiscountPercent.toggle()
        hideKeyboard()
    }
    
    @IBAction func didTapAllServices(_ sender: Any) {
        if isSelectAllServices {
            return
        }
        isSelectAllServices.toggle()
        isSelectService.toggle()
        hideKeyboard()
    }
    
    @IBAction func didTapSpecificService(_ sender: Any) {
        if isSelectService{
            return
        }
        isSelectService.toggle()
        isSelectAllServices.toggle()
        hideKeyboard()
    }
    
    @IBAction func didTapSetToActive(_ sender: Any) {
        isSelectSetToActive.toggle()
    }
    
    @IBAction func showDropDownCreator(_ sender: Any) {
        dropDownCreator.show()
    }
    
    @IBAction func showDropDownService(_ sender: Any) {
        dropDownService.show()
    }
    
    @IBAction func showDropDownApplyTo(_ sender: Any) {
        dropDownApplyTo.show()
    }
    
    @IBAction func showDropDownDiscountType(_ sender: Any) {
        dropDownDiscountType.show()
    }
    
    @IBAction func didTapAddApplyTo(_ sender: Any) {
        guard let applyTo = applyToTextField.text, !applyTo.isEmpty, !applyToContentView.tagViews.contains(where: { $0.titleLabel?.text == applyTo }) else { return }
        applyToContentView.addTag(applyTo)
        checkApplyToTagDisplay()
    }
    
    @IBAction func didTapAddService(_ sender: Any) {
        guard let specificService = specificServiceTextField.text, !specificService.isEmpty, !specificServiceContentView.tagViews.contains(where: { $0.titleLabel?.text == specificService }) else { return }
        specificServiceContentView.addTag(specificService)
        checkSpecificServiceTagDisplay()
    }
}

extension CreateNewPromotionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case promotionNameTextField:
            promotionCodeTextField.becomeFirstResponder()
        case promotionCodeTextField:
            startDateTextField.becomeFirstResponder()
        case startDateTextField:
            endDateTextField.becomeFirstResponder()
        case endDateTextField:
            valueDiscountPercentTextField.becomeFirstResponder()
        case valueDiscountPercentTextField:
            valueDiscountNumberMoneyTextField.becomeFirstResponder()
        case valueDiscountNumberMoneyTextField:
            maxDiscountAmountTextField.becomeFirstResponder()
        case maxDiscountAmountTextField:
            numberOfGiftCodeTextField.becomeFirstResponder()
        case numberOfGiftCodeTextField:
            discountCodeTextField.becomeFirstResponder()
        default:
            hideKeyboard()
        }
        return true
    }
}

extension CreateNewPromotionVC: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        switch sender {
        case applyToContentView:
            applyToContentView.removeTagView(tagView)
        case specificServiceContentView:
            specificServiceContentView.removeTagView(tagView)
        default:
            break
        }
    }
}
