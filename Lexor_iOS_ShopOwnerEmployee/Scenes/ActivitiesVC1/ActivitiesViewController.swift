//
//  ActivitiesViewController.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 04/08/2021.
//

import UIKit

final class ActivitiesViewController: UIViewController {

    @IBOutlet weak var allTabButton: UIButton!
    @IBOutlet weak var newTabButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var underLineNewTabView: UIView!
    @IBOutlet weak var underLineOtherView: UIView!
    @IBOutlet weak var otherTabButton: UIButton!
    @IBOutlet weak var underLineAllTabView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!

    var viewModel = ActivitiesViewModel()
    var noticeView: NoticeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
    }
    
    func configView() {
        viewModel.delegate = self
        emptyLabel.isHidden = true
    }
    
    func configTableView() {
        tableView.registerNibCellFor(type: NotificationCell.self)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableView.automaticDimension      
    }
    
    @IBAction func clearNotificationBtnTouchUpInside(_ sender: Any) {
        noticeView = NoticeView()
        noticeView?.frame = self.view.bounds
        
        noticeView?.delegate = self
        guard let noticeView = noticeView else {
            return
        }
        view.addSubview(noticeView)
        
    }
    
    @IBAction func tabButtonTouchUpInside(_ button: UIButton) {
        switch button {
        case allTabButton:
            viewModel.selecttab = 1
            
        case newTabButton:
            viewModel.selecttab = 2
        case otherTabButton:
            viewModel.selecttab = 3
        default:
            break
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
        label.text = viewModel.notifyResponse[section].dateStr
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.notifyResponse[indexPath.section].listNotification[indexPath.row].isExpend = !viewModel.notifyResponse[indexPath.section].listNotification[indexPath.row].isExpend
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.notifyResponse[indexPath.section].listNotification[indexPath.row].isExpend {
            return UITableView.automaticDimension
        } else {
            return 150
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
                    this.viewModel.notifyResponse.removeAll()
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
    func viewModel(tabNumber: Int, needPerformAction action: ActivitiesViewModel.Action) {
        switch tabNumber {
        case 1:
            underLineAllTabView.backgroundColor =  UIColor(hexString: "fc978b")
            underLineNewTabView.backgroundColor =  UIColor.white
            underLineOtherView.backgroundColor =  UIColor.white
        case 2:
            underLineAllTabView.backgroundColor =  UIColor.white
            underLineNewTabView.backgroundColor =  UIColor(hexString: "fc978b")
            underLineOtherView.backgroundColor =  UIColor.white
        case 3:
            underLineAllTabView.backgroundColor =  UIColor.white
            underLineNewTabView.backgroundColor =  UIColor.white
            underLineOtherView.backgroundColor =  UIColor(hexString: "fc978b")
        
        default:
        break
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
