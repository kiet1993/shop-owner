//
//  ActivitiesViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 05/08/2021.
//

import Foundation
protocol ActivitiesViewModelDelegate: AnyObject {
    func viewModel(tabNumber: Int, needPerformAction action: ActivitiesViewModel.Action)
}

class ActivitiesViewModel {
    enum Action {
        case changeAction
    }
    
    var notifyResponse: [NotificationRespone]  = [NotificationRespone(
                                                        dateStr: "Mon,31-10-2021",
                                                        listNotification: [NotificationData(content: "hih", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false)]),
                                                      NotificationRespone(dateStr: "Mon,31-10-2021", listNotification: [NotificationData(content: "Tus,1-11-2021", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false)]),
                                                      NotificationRespone(dateStr: "Sun,31-10-2021", listNotification: [NotificationData(content: "hih", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false),NotificationData(content: "Tus,1-11-2021", isExpend: false)])]
    weak var delegate: ActivitiesViewModelDelegate?
    
    struct NotificationData {
        var content: String
        var isExpend: Bool
    }
    
    struct NotificationRespone {
        var dateStr: String
        var listNotification: [NotificationData]
    }
    var selecttab: Int = 1 {
        didSet {
            delegate?.viewModel(tabNumber: selecttab, needPerformAction: .changeAction)
        }
    }
    
    func numberOfSections()-> Int{
        return notifyResponse.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return notifyResponse[section].listNotification.count
    }
}


