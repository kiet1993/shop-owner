//
//  ProductListViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/8/21.
//

import UIKit

class ProductListViewController: BaseController {
    @IBOutlet weak var sliderTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tfSearch: CustomLeftIconTextfield!
    @IBOutlet weak var btnCreateProduct: UIButton!
    @IBOutlet weak var tableviewProduct: UITableView!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
//    private var viewModel: ProductListViewModelType
//
//    init(viewModel: ProductListViewModelType) {
//        self.viewModel = viewModel
//        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
//    }

    var  viewModel = ProductListViewModel()

    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.filteredSimpleProducts = viewModel.simpleProducts
//        viewModel.filteredBundleProducts = viewModel.bundleProducts

        headerView.addShadow(ofColor: UIColor.primaryPink, radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.25)
        bottomView.addShadow(ofColor: UIColor.primaryPink, radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.25)
        view.backgroundColor = UIColor.contentPink
        btnCreateProduct.layer.cornerRadius = 10
        
        tableviewProduct.backgroundColor = .clear
        tableviewProduct.separatorColor = .clear
        tableviewProduct.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
//        tableviewProduct.register(SimpleProductTableViewCell.self)
//        tableviewProduct.register(BundleProductTableViewCell.self)
        tableviewProduct.register(DummyListProductCell.self)
        tableviewProduct.delegate = self
        tableviewProduct.dataSource = self
        tableviewProduct.keyboardDismissMode = .onDrag
        tfSearch.delegate = self
        
        setTitle(text: "Product List", color: #colorLiteral(red: 0.9882352941, green: 0.5921568627, blue: 0.5450980392, alpha: 1))
        
        let icSearch = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        tfSearch.leftViewMode = .always
        let leftView = UIImageView(image: icSearch)
        leftView.tintColor = .black
        tfSearch.leftView = leftView
        tfSearch.addDoneButtonOnKeyboard()
        
        switch viewModel.screenType {
        case .simple:
            btnCreateProduct.setTitle("Create New Simple Product", for: .normal)
            sliderLeadingConstraint.isActive = true
            sliderTrailingConstraint.isActive = false
        case .bundle:
            btnCreateProduct.setTitle("Create New Bundle Product", for: .normal)
            self.sliderLeadingConstraint.isActive = false
            self.sliderTrailingConstraint.isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHiddenNavigation(false, animated: animated)
        createProduct()
    }
    
    private func changeViewState(isSimpple: Bool) {
        let text = isSimpple ? "Create New Simple Product" : "Create New Bundle Product"
        btnCreateProduct.setTitle(text, for: .normal)
        UIView.animate(withDuration: 0.2) {
            self.sliderLeadingConstraint.isActive = isSimpple
            self.sliderTrailingConstraint.isActive = !isSimpple
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnSimpleTapped(_ sender: Any) {
        viewModel.screenType = .simple
        changeViewState(isSimpple: true)
//        if let textSearch = tfSearch.text, !textSearch.isEmpty {
//            viewModel.filteredSimpleProducts = viewModel.simpleProducts.filter({$0.name.lowercased().contains(textSearch.lowercased())})
//        } else {
//            viewModel.filteredSimpleProducts = viewModel.simpleProducts
//        }
        tableviewProduct.reloadData()
    }

    private func createProduct() {
        HUD.show()
        viewModel.getListProduct { [weak self] result in
            HUD.dismiss()
            guard let this = self else {return}
            switch result {
            case .success:
                this.tableviewProduct.reloadData()
            case .failure(let err):
                this.showNormalError(err)
            }
        }
    }
    
    @IBAction func btnBundleTapped(_ sender: Any) {
        viewModel.screenType = .bundle
        changeViewState(isSimpple: false)
//        if let textSearch = tfSearch.text, !textSearch.isEmpty {
//            viewModel.filteredBundleProducts = viewModel.bundleProducts.filter({$0.name.lowercased().contains(textSearch.lowercased())})
//        } else {
//            viewModel.filteredBundleProducts = viewModel.bundleProducts
//        }
        tableviewProduct.reloadData()
    }
    
    @IBAction func btnCreateProductTapped(_ sender: Any) {
        switch viewModel.screenType {
        case .simple:
            let vc = NewSimpleProductViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .bundle:
            let vc = NewBundleProductViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.screenType {
        case .bundle:
            labelEmpty.isHidden = viewModel.filteredBundleProducts.count > 0
            return viewModel.filteredBundleProducts.count
        case .simple:
            labelEmpty.isHidden = viewModel.filteredSimpleProducts.count > 0
            return viewModel.filteredSimpleProducts.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DummyListProductCell = tableView.dequeueReusableCell(withClass: DummyListProductCell.self, for: indexPath)
        switch viewModel.screenType {
        case .simple:
            let model = viewModel.filteredSimpleProducts[indexPath.row]
            cell.configCell(skuString: model.sku, typeIDString: model.typeID, uuddString: model.uuid)
            return cell
        case .bundle:
            let model = viewModel.filteredBundleProducts[indexPath.row]
            cell.configCell(skuString: model.sku, typeIDString: model.typeID, uuddString: model.uuid)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch viewModel.screenType {
//        case .bundle:
//            let cell: BundleProductTableViewCell = tableView.dequeueReusableCell(withClass: BundleProductTableViewCell.self, for: indexPath)
//            let model = viewModel.filteredBundleProducts[indexPath.row]
//            cell.configCell(model: model)
//            return cell
//        case .simple:
//            let cell: SimpleProductTableViewCell = tableView.dequeueReusableCell(withClass: SimpleProductTableViewCell.self, for: indexPath)
//            let model = viewModel.filteredSimpleProducts[indexPath.row]
//            cell.configCell(model: model, type: .edit)
//            return cell
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.screenType {
        case .bundle:
            return UITableView.automaticDimension
        case .simple:
            return UITableView.automaticDimension
        }
    }
}

extension ProductListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string1 = string
        let string2 = textField.text
        var finalString = ""
        if string.count > 0 { // if it was not delete character
            finalString = string2! + string1
        } else if let string2 = string2, string2.count > 0 { // if it was a delete character
            finalString = String(string2.dropLast())
        }
        
//        switch viewModel.screenType {
//        case .simple:
//            if finalString.isEmpty {
//                viewModel.filteredSimpleProducts = viewModel.simpleProducts
//            } else {
//                viewModel.filteredSimpleProducts = viewModel.simpleProducts.filter({$0.name.lowercased().contains(finalString.lowercased())})
//            }
//        case .bundle:
//            if finalString.isEmpty {
//                viewModel.filteredBundleProducts = viewModel.bundleProducts
//            } else {
//                viewModel.filteredBundleProducts = viewModel.bundleProducts.filter({$0.name.lowercased().contains(finalString.lowercased())})
//            }
//        }
        tableviewProduct.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
