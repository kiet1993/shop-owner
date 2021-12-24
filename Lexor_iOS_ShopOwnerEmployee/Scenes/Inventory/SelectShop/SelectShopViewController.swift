//
//  SelectShopViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 21/08/2021.
//

import UIKit

protocol SelectShopViewControllerDlegate: AnyObject {
    func view(_ view: SelectShopViewController, needPerformAction action: SelectShopViewController.Action)
}

final class SelectShopViewController: BaseController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private  weak var containerView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var btnDone: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    enum Action {
        case closeSelect
        case doneSelect
    }

    var viewModel = SelectShopViewModel()
    weak var delegate: SelectShopViewControllerDlegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor.contentPink
        headerView.addShadow(ofColor: UIColor.primaryPink, radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.25)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.primaryPink.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShopProductCell.self)
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 35, right: 0)
        viewModel.delegate = self
    }

    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        delegate?.view(self, needPerformAction: .doneSelect)
    }

    @IBAction func closeButtonTouchUpÍnide(_ sender: Any) {
        delegate?.view(self, needPerformAction: .closeSelect)
    }
}
extension SelectShopViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shopList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopProductCell = tableView.dequeueReusableCell(withClass: ShopProductCell.self, for: indexPath)
        let model = viewModel.shopList[indexPath.row]
        cell.configCell(isSelect: model.selectedShop, nameStr: model.tax)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItemWith(indexPath.row)
    }


}

extension SelectShopViewController: SelectShopViewModelDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
        #warning("Handle push sellect shop to HomeViewConTroller")
    }
}
