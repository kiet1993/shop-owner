//
//  ManagePromotionVC.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 11/10/2021.
//

import UIKit

class ManagePromotionVC: BaseController {

    @IBOutlet weak var searchTextField: CustomLeftIconTextfield!
    @IBOutlet weak var listPromotionCollectionView: UICollectionView!
    @IBOutlet weak var addNewPromotionButton: UIButton!
    
    var viewModel: ManagePromotionViewModelType?
    private let refreshControl = UIRefreshControl()
    private var keyword = ""
    
    init (managePromotionViewModel: ManagePromotionViewModelType) {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        self.viewModel = managePromotionViewModel
        self.viewModel?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindingViewModel()
        loadData(promotionName: "", withLoadingIndicator: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleHiddenNavigation(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private func setupUI() {
        setTitle(text: "Manage Promotion", color: UIColor(hexString: "EE9C8F"))
        view.backgroundColor = UIColor.contentPink
        
        let icSearch = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let leftView = UIImageView(image: icSearch)
        leftView.tintColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.leftViewMode = .always
        searchTextField.leftView = leftView
        searchTextField.delegate = self
        
        addNewPromotionButton.layer.cornerRadius = 10
        addNewPromotionButton.setTitle("Add new Promotion", for: .normal)
        
        listPromotionCollectionView.register(UINib(nibName: "PromotionCell", bundle: nil), forCellWithReuseIdentifier: "PromotionCell")
        listPromotionCollectionView.delegate = self
        listPromotionCollectionView.dataSource = self
        listPromotionCollectionView.backgroundColor = .contentPink
        listPromotionCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        if let searchKey = searchTextField.text {
            loadData(promotionName: searchKey, withLoadingIndicator: false)
        }
    }
    
    @objc func placeAutocomplete() {
        if let keyword = searchTextField.text, keyword != self.keyword {
            self.keyword = keyword
            loadData(promotionName: keyword, withLoadingIndicator: false)
        }
    }
    
    private func loadData(promotionName: String, withLoadingIndicator: Bool) {
        viewModel?.getListPromotion(promotionName: promotionName, withLoadingIndicator: withLoadingIndicator)
    }
    
    private func bindingViewModel() {
        viewModel?.loading = { (isLoading) in
            isLoading ? HUD.show() : HUD.dismiss()
        }
    }
    
    @IBAction func searchTextFieldDidChange(_ sender: Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(placeAutocomplete), object: nil)
        perform(#selector(placeAutocomplete), with: nil, afterDelay: 0.5)
    }
    
    @IBAction func didTapAddNewPromotion(_ sender: Any) {
        let createPromotionVC = CreateNewPromotionVC(createNewPromotionViewModel: CreateNewPromotionViewModel.init())
        navigationController?.pushViewController(createPromotionVC, animated: true)
    }
}

extension ManagePromotionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension ManagePromotionVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel?.loadPromotionsState {
        case .loaded(let promotions):
            return promotions.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as? PromotionCell else {
            fatalError("Impossible case!!!")
        }
        switch viewModel?.loadPromotionsState {
        case .loaded(let promotions):
            cell.setData(promotion: promotions[indexPath.item])
            cell.delegate = self
        default:
            break
        }
        return cell
    }
}

extension ManagePromotionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heightOfCell: CGFloat = 0
        switch viewModel?.loadPromotionsState {
        case .loaded(let promotions):
            if promotions[indexPath.item].isExpanded {
                heightOfCell = 200
            } else {
                heightOfCell = 40
            }
        default:
            heightOfCell = 40
        }
        return CGSize(width: collectionView.bounds.size.width - 20, height: heightOfCell)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension ManagePromotionVC: ManagePromotionViewModelDelegate {
    func didLoadPromotions(viewModel: ManagePromotionViewModel) {
        listPromotionCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension ManagePromotionVC: PromotionCellDelegate {
    func didTapShowInfoPromotion(promotion: PromotionType) {
        viewModel?.updateExpandedPromotion(promotion: promotion)
    }
    
    func didChangeOnOffPromotion(isOn: Bool) {
        
    }
}
