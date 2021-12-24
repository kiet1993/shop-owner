//
//  HomeViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/24/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class HomeViewController: BaseController {

    // MARK: - IBOutlets
    @IBOutlet private weak var statusBarBackgroundView: UIView!
    @IBOutlet private weak var statusBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var homeHeaderView: HomeHeaderView!
    @IBOutlet private weak var homeMenuView: HomeMenuView!
    @IBOutlet private weak var groupStackView: UIStackView!

    var viewModel = HomeViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActionHandler()
//        getListShop()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        homeHeaderView.applyGradient(colors: [.primaryPink, .secondaryPink],
                                               startPoint: .zero,
                                               endPoint: .init(x: 0, y: 1))
        homeHeaderView.roundCorners(corners: [.bottomLeft, .bottomRight],
                                              radius: 20)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func getListShop() {
        view.endEditing(true)
        HUD.show()
        viewModel.getListShop { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                this.handleListShop()
            case .failure(let error):
                this.showNormalError(error)
            }
        }
    }

    private func handleListShop() {
        switch viewModel.listProductResponse?.data.rows.count {
        case 0:
            groupStackView.isHidden =  true
            homeMenuView.isUserInteractionEnabled = false
        case 1:
            homeMenuView.isUserInteractionEnabled = true
            viewModel.listProductResponse?.data.rows[0].selectedShop = true
        default:
            viewModel.listProductResponse?.data.rows[0].selectedShop = true
            homeMenuView.isUserInteractionEnabled = true
            let vc = SelectShopViewController()
            guard let shopList = viewModel.listProductResponse?.data.rows else { return }
            vc.viewModel.shopList = shopList
            vc.delegate = self

            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
}

// MARK: - Extension HomeViewController
extension HomeViewController {

    // MARK: Private functions
    private func setupUI() {
        /// `Status Bar View`
        statusBarBackgroundView.backgroundColor = UIColor.primaryPink
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            statusBarHeightConstraint.constant = height
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            if let height = statusBar?.frame.height {
                statusBarHeightConstraint.constant = height
            }
        }

        /// `Container view`
        containerView.backgroundColor = UIColor.contentPink
        
        /// `headerContainerView`
        homeHeaderView.updateView(with: HomeHeaderViewModel(avatarImage: #imageLiteral(resourceName: "img-home-avatar"),
                                                                 userName: "Tran Nhat Duy",
                                                                 point: 5_000))


        for group in HomeViewModel.homeItems {
            let groupView = HomeGroupView()
            groupView.updateView(with: HomeGroupViewModel(title: group.categoryName,
                                                          items: group.items))
            groupView.itemTapHandler = { [weak self] item in
                guard let this = self else { return }
                this.groupItemTapHandler(from: item)
            }
            groupStackView.addArrangedSubview(groupView)
        }
    }

    private func setupActionHandler() {
        /// `Menu View`
        homeMenuView.profileTapHandler = {
            print("☘️ profileTapHandler")
        }

        homeMenuView.messengerTapHandler = {
            print("☘️ messengerTapHandler")
        }

        homeMenuView.shopSelectionTapHandler = {
            let vc = SelectShopViewController()
            vc.delegate = self
            guard let shopList = self.viewModel.listProductResponse?.data.rows else { return }
            vc.viewModel.shopList = shopList
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }

    private func groupItemTapHandler(from itemInfo: HomeViewModel.ItemInfo) {
        print("☘️ \(#function) \(itemInfo.title)")
        switch itemInfo {
        case .virtualProduct:
          //  let vm = ProductListViewModel(screenType: .simple)
            let vc = ProductListViewController()
            vc.viewModel.screenType = .simple
            self.navigationController?.pushViewController(vc, animated: true)
        case .bundleProduct:
           //. let vm = ProductListViewModel(screenType: .bundle)
            let vc = ProductListViewController()
            vc.viewModel.screenType = .bundle
            self.navigationController?.pushViewController(vc, animated: true)
        case .giftCardCoupon:
            let vc = ManagePromotionVC(managePromotionViewModel: ManagePromotionViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension HomeViewController: SelectShopViewControllerDlegate {
    func view(_ view: SelectShopViewController, needPerformAction action: SelectShopViewController.Action) {
        switch action {
        case .closeSelect:
            navigationController?.dismiss(animated: false)
        case .doneSelect:
            navigationController?.dismiss(animated: false)
        }
    }
}
