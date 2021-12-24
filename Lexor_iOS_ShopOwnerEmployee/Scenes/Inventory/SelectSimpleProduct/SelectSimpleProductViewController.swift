//
//  SelectSimpleProductViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Macintosh on 8/9/21.
//

import UIKit

protocol SelectSimpleProductViewControllerDelegate: AnyObject {
    func didSelectProducts(_ products: [SimpleProductModel])
}
class SelectSimpleProductViewController: BaseController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tfSearch: CustomLeftIconTextfield!
    @IBOutlet weak var tableviewProduct: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var labelSelectedProduct: UILabel!
    
    private var viewModel: SelectSimpleProductViewModelType
    private weak var delegate: SelectSimpleProductViewControllerDelegate?
    
    init(viewModel: SelectSimpleProductViewModelType, delegate: SelectSimpleProductViewControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(text: "Product List", color: .primaryPink)
        headerView.addShadow(ofColor: UIColor.primaryPink, radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.25)
        view.backgroundColor = UIColor.contentPink
        btnDone.layer.cornerRadius = 10
        
        viewModel.filteredSimpleProducts = viewModel.simpleProducts
        
        tableviewProduct.backgroundColor = .clear
        tableviewProduct.separatorColor = .clear
        tableviewProduct.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 65, right: 0)
        tableviewProduct.register(SimpleProductTableViewCell.self)
        tableviewProduct.delegate = self
        tableviewProduct.dataSource = self
        
        tfSearch.delegate = self
        tfSearch.addDoneButtonOnKeyboard()
        let icSearch = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        tfSearch.leftViewMode = .always
        let leftView = UIImageView(image: icSearch)
        leftView.tintColor = .black
        tfSearch.leftView = leftView
        
        viewModel.delegate = self
        viewModel.checkSelectedProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHiddenNavigation(false, animated: animated)
    }
    
    private func setupLabelSelectdProduct(_ text: String) {
        if text.isEmpty {
            labelSelectedProduct.text = nil
        } else {
            let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
            let attrs2 = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 16)]
            let attributedString1 = NSMutableAttributedString(string:"Selected Product: ", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:text, attributes:attrs2)
            attributedString1.append(attributedString2)
            labelSelectedProduct.attributedText = attributedString1
        }
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        delegate?.didSelectProducts(viewModel.simpleProducts.filter({$0.isSelect}))
        navigationController?.popViewController(animated: true)
    }
}

extension SelectSimpleProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labelEmpty.isHidden = viewModel.filteredSimpleProducts.count > 0
        return viewModel.filteredSimpleProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SimpleProductTableViewCell = tableView.dequeueReusableCell(withClass: SimpleProductTableViewCell.self, for: indexPath)
        let model = viewModel.filteredSimpleProducts[indexPath.row]
        cell.configCell(model: model, type: .select)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.filteredSimpleProducts[indexPath.row]
        viewModel.didSelectItemWith(model.id)
    }
}

extension SelectSimpleProductViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string1 = string
        let string2 = textField.text
        var finalString = ""
        if string.count > 0 { // if it was not delete character
            finalString = string2! + string1
        } else if let string2 = string2, string2.count > 0 { // if it was a delete character
            finalString = String(string2.dropLast())
        }
        if finalString.isEmpty {
            viewModel.filteredSimpleProducts = viewModel.simpleProducts
        } else {
            viewModel.filteredSimpleProducts = viewModel.simpleProducts.filter({$0.name.lowercased().contains(finalString.lowercased())})
        }
        tableviewProduct.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SelectSimpleProductViewController: SelectSimpleProductViewModelDelegate {
    func setSelectedProductLabel(_ text: String) {
        setupLabelSelectdProduct(text)
    }
    
    func reloadTableView() {
        tableviewProduct.reloadData()
    }
    
}
