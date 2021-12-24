//
//  NewBundleProductViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import UIKit

class NewBundleProductViewController: BaseController {
    @IBOutlet weak var tfProductName: CustomLeftIconTextfield!
    @IBOutlet weak var tfSKU: CustomLeftIconTextfield!
    @IBOutlet weak var tfPrice: CustomLeftIconTextfield!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var labelListProduct: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    var selectedImage: UIImage? {
        didSet {
            imageThumbnail.image = self.selectedImage
        }
    }
    private var products = [SimpleProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.contentPink
        btnSave.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        setTitle(text: "New Bundle", color: .primaryPink)
        btnAddPhoto.setImage(btnAddPhoto.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnAddPhoto.tintColor = .primaryPink
        
        tfProductName.addDoneButtonOnKeyboard()
        tfSKU.addDoneButtonOnKeyboard()
        tfPrice.addDoneButtonOnKeyboard()
        
        tfProductName.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tfSKU.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tfPrice.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        imageThumbnail.image = #imageLiteral(resourceName: "image-placeholder")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHiddenNavigation(false, animated: animated)
    }
    
    @IBAction func btnAddImageTapped(_ sender: Any) {
        requestPermissionAndPickPhotos(delegate: self)
    }
    
    @IBAction func btnAddProductTapped(_ sender: Any) {
        let vm = SelectSimpleProductViewModel(selectedIds: products.map({$0.id}))
        let vc = SelectSimpleProductViewController(viewModel: vm, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
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
        } else if products.count == 0 {
            errorText = "Please add products."
        } else if selectedImage == nil {
            errorText = "Please pick image."
        }
        
        if let error = errorText {
            showAlert(title: "Error", message: error)
            return
        }
        showAlert(title: "Message", message: "Create bundle product successfully.", handler:  {
            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension NewBundleProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        selectedImage = image
    }
}

extension NewBundleProductViewController: SelectSimpleProductViewControllerDelegate {
    func didSelectProducts(_ products: [SimpleProductModel]) {
        self.products = products
        labelListProduct.text = products.map({$0.name}).joined(separator: ", ")
    }
}
