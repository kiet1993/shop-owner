//
//  ActivitiesViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 04/08/2021.
//

import UIKit

final class ActivitiesViewController: UIViewController {

    @IBOutlet private weak var allTabButton: UIButton!
    @IBOutlet private weak var newTabButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var underLineNewTabView: UIView!
    @IBOutlet private weak var underLineOtherView: UIView!
    @IBOutlet private weak var otherTabButton: UIButton!
    @IBOutlet private weak var underLineAllTabView: UIView!
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    
    var viewModel = ActivitiesViewModel()
    var noticeView: NoticeView?
    var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        getNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configView() {
        view.backgroundColor = UIColor.contentPink
        viewModel.delegate = self
        emptyLabel.isHidden = true
        headerView.addShadow(ofColor: UIColor.primaryPink, radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.25)
    }
    
    private func configTableView() {
        tableView.register(NotificationCell.self)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction private func clearNotificationBtnTouchUpInside(_ sender: Any) {
        noticeView = NoticeView()
        noticeView?.frame = UIScreen.main.bounds
        
        noticeView?.delegate = self
        guard let noticeView = noticeView else {
            return
        }
        AppDelegate.shared.appCoordinator.appTabbarController.view.addSubview(noticeView)
    }
    
    @IBAction private func tabButtonTouchUpInside(_ button: UIButton) {
        switch button {
        case allTabButton:
            viewModel.noticeType = .all
        case newTabButton:
            viewModel.noticeType = .new
        case otherTabButton:
            viewModel.noticeType = .other
        default:
            break
        }
        getNotifications()
        emptyLabel.isHidden = !viewModel.notifyResponse.isEmpty
    }

    private func getNotifications() {
        HUD.show()
        viewModel.getNotifications(){ [weak self] result in
            HUD.dismiss()
            guard let this = self else {return}
            switch result {
            case .success:
                this.tableView.reloadData()
            case .failure(let err):
                this.showNormalError(err)
            }
        }
    }
}

extension ActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.bounds.width, height: 30))
        headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: headerView.bounds.width / 2 - headerView.bounds.width / 6, y: headerView.bounds.height - Config.titleHeaderBottom - Config.fontNomal.lineHeight - 10 ,
                                          width: headerView.bounds.width / 3, height: Config.fontNomal.lineHeight))
        label.textColor = UIColor(hexString: "467780")
        label.font = Config.fontNomal
        label.text = Array(viewModel.newGroupData)[section].key
        label.textAlignment  = .center
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        headerView.addSubview(label)
        label.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.equalTo(140)
        })
        headerView.layoutIfNeeded()
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = tableView.dequeueReusableCell(withClass: NotificationCell.self, for: indexPath)
        cell.viewModel = viewModel.notificationCellViewModel(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !viewModel.isLoadingMore, !isFirstLoad,
              indexPath.row == viewModel.numberOfItems(inSection: indexPath.section) - 3,
              viewModel.canLoadMore() else { return }
        viewModel.loadMore { result in
            switch result {
            case .success:
                tableView.reloadData()
            case .failure:
                break
            }
        }
    }
}

extension ActivitiesViewController: NoticeViewDelegate {
    func view(_ view: NoticeView, needPerformAction action: NoticeView.Action) {
        switch action {
        case .deleteNotice:
            guard  !viewModel.notifyResponse.isEmpty else { return }
            showAlert(title: "", message: Config.alertMessage, buttonTitles: [Config.okTitle, Config.cancelTitle], completion: { [weak self] buttonIndex in
                guard let this = self else { return }
                switch buttonIndex {
                case 0:
                    this.noticeView?.removeFromSuperview()
                    #warning("call api delete after")
                    this.tableView.reloadData()
                    this.emptyLabel.isHidden = !this.viewModel.notifyResponse.isEmpty
                case 1:
                    this.noticeView?.removeFromSuperview()
                default:
                    break
                }
            })
        case .turnOffAllert:
            self.noticeView?.removeFromSuperview()
        }
    }
}

extension ActivitiesViewController: ActivitiesViewModelDelegate {
    func viewModel(noticeType: ActivitiesViewModel.NoticeType, needPerformAction action: ActivitiesViewModel.Action) {
        switch noticeType {
        case .all:
            underLineAllTabView.backgroundColor =  UIColor(hexString: "fc978b")
            underLineNewTabView.backgroundColor =  UIColor.white
            underLineOtherView.backgroundColor =  UIColor.white
        case .new:
            underLineAllTabView.backgroundColor =  UIColor.white
            underLineNewTabView.backgroundColor =  UIColor(hexString: "fc978b")
            underLineOtherView.backgroundColor =  UIColor.white
        case .other:
            underLineAllTabView.backgroundColor =  UIColor.white
            underLineNewTabView.backgroundColor =  UIColor.white
            underLineOtherView.backgroundColor =  UIColor(hexString: "fc978b")
        }
    }
}

extension ActivitiesViewController {
    struct HeaderHeight {
        static let spendingSection: CGFloat = 0
        static let statementSection: CGFloat = 52
    }
    
    struct Config {
        static var grayColorStr: String = "555555"
        static let titleHeaderBottom: CGFloat = 8
        static let titleHeaderTrailing: CGFloat = 16
        static let otherSectionFooterHeight: CGFloat = 56
        static let fontNomal: UIFont! = UIFont.systemFont(ofSize: 15)
        static let alertMessage: String = "Do you want to clear all?"
        static let okTitle: String = "OK"
        static let cancelTitle: String = "Cancel"
    }
}
