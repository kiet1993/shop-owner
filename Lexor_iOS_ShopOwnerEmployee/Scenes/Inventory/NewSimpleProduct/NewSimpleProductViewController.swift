//
//  NewSimpleProductViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import UIKit

class NewSimpleProductViewController: BaseController {
    @IBOutlet weak var tfProductName: CustomLeftIconTextfield!
    @IBOutlet weak var tfSKU: CustomLeftIconTextfield!
    @IBOutlet weak var tfPrice: CustomLeftIconTextfield!
    @IBOutlet weak var tfQuantity: CustomLeftIconTextfield!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    var selectedImage: UIImage? {
        didSet {
            imageThumbnail.image = self.selectedImage
        }
    }
    
    var viewModel = NewSimpleProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.contentPink
        btnSave.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        setTitle(text: "New Simple Product", color: .primaryPink)
        btnAddPhoto.setImage(btnAddPhoto.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnAddPhoto.tintColor = .primaryPink
        
        tfProductName.addDoneButtonOnKeyboard()
        tfSKU.addDoneButtonOnKeyboard()
        tfPrice.addDoneButtonOnKeyboard()
        tfQuantity.addDoneButtonOnKeyboard()
        
        tfProductName.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tfSKU.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tfPrice.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tfQuantity.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        imageThumbnail.image = #imageLiteral(resourceName: "image-placeholder")
        tfSKU.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHiddenNavigation(false, animated: animated)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        view.endEditing(true)
        
        var errorText: String?
        if let tfText = tfProductName.text, tfText.isEmpty {
            errorText = "Please input production name."
        } else if let tfText = tfSKU.text, tfText.isEmpty {
            errorText = "Please input SKU."
        } else if let tfText = tfPrice.text, tfText.isEmpty {
            errorText = "Please input price."
        } else if let tfText = tfQuantity.text, tfText.isEmpty {
            errorText = "Please input quantity."
        } else if selectedImage == nil {
            errorText = "Please pick image."
        }
        
        if let error = errorText {
            showAlert(title: "Error", message: error)
            return
        }
        createProduct()
    }
    
    @IBAction func btnAddImageTapped(_ sender: Any) {
        requestPermissionAndPickPhotos(delegate: self)
    }
    
    private func createProduct() {
        HUD.show()
        viewModel.createProduct { [weak self] result in
            HUD.dismiss()
            guard let this = self else {return}
            switch result {
            case .success:
                this.showAlert(title: "Message", message: "Create simple product successfully.", handler:  {
                    this.navigationController?.popViewController(animated: true)
                })
            case .failure(let err):
                this.showNormalError(err)
            }
        }
    }
}

extension NewSimpleProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        selectedImage = image
    }
}

extension NewSimpleProductViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString = textField.text.content as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        switch textField {
        case tfSKU:
            viewModel.sku = newText
        default:
            break
        }
        return true
    }
    
}
