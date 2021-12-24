//
//  ActivitiesViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 05/08/2021.
//

import Foundation
protocol ActivitiesViewModelDelegate: AnyObject {
    func viewModel(noticeType: ActivitiesViewModel.NoticeType, needPerformAction action: ActivitiesViewModel.Action)
}

class ActivitiesViewModel {

    enum Action {
        case changeAction
    }
    
    enum NoticeType: String {
        case all = ""
        case new = "0"
        case other = "1"
    }

    weak var delegate: ActivitiesViewModelDelegate?
    var notificationResponse:NotificationResponse?
    var notifyResponse: [NotificationRow] = []
    var datesDuplicate: [Date] = []
    var newGroupData: [String: [NotificationRow]] = [:]
    private(set) var isLoadingMore: Bool = false

    lazy var notifyDateFormatter: DateFormatter = {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.calendar = Calendar(identifier: .gregorian)
        serverDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        serverDateFormatter.dateFormat = "E, d MMM yyyy"
        return serverDateFormatter
    }()

    var noticeType: NoticeType = NoticeType.all {
        didSet {
            delegate?.viewModel(noticeType: noticeType, needPerformAction: .changeAction)
        }
    }
    
    private func prepairData() {

        if let rows = notificationResponse?.data.rows {
            notifyResponse = rows
        }
        datesDuplicate = notifyResponse.compactMap({ $0.createdAtDate })
        datesDuplicate = unique(dates: datesDuplicate)
        newGroupData.removeAll()
        let datesDuplicateStrs = datesDuplicate.map({ notifyDateFormatter.string(from: $0) })

        for (index, key) in datesDuplicateStrs.enumerated() {
            if let empty = newGroupData[key]?.isEmpty, !empty {
                newGroupData[key]?.append(contentsOf: notifyResponse.filter({
                    if let createdAt = $0.createdAtDate {
                        return Calendar.current.compare(datesDuplicate[index], to: createdAt, toGranularity: .day) == .orderedSame
                    }
                    return false
                }))
            } else {
                newGroupData[key] = notifyResponse.filter({
                    if let createdAt = $0.createdAtDate {
                        return Calendar.current.compare(datesDuplicate[index], to: createdAt, toGranularity: .day) == .orderedSame
                    }
                    return false
                })
            }
        }
    }

    private func unique(dates: [Date]) -> [Date] {
        var answerDates: [Date] = []
        for date in dates {
            if answerDates.first(where: {
                Calendar.current.compare($0, to: date, toGranularity: .day) == .orderedSame
            }) == nil {
                answerDates.append(date)
            }
        }
        return answerDates
    }
    
    func numberOfSections()-> Int{
        return newGroupData.keys.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return Array(newGroupData.values)[section].count
    }

    func getNotifications(completion: @escaping APICompletion) {
        APIRequest.getNotifications(status: noticeType.rawValue, q: "") { [weak self] result in
            guard let this = self else {return}
            switch result {
            case .success(let value):
                this.notificationResponse = value
                this.prepairData()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ActivitiesViewModel {
    func notificationCellViewModel(indexPath: IndexPath) -> NotificationCellViewModel {
        var createdAtStr = ""
        if let date = Array(newGroupData)[indexPath.section].value[indexPath.row].createdAtDate {
            createdAtStr = notifyDateFormatter.string(from: date )
        }
        return NotificationCellViewModel(
            title: Array(newGroupData)[indexPath.section].value[indexPath.row].title,
            date: createdAtStr ,
            discription: Array(newGroupData)[indexPath.section].value[indexPath.row].fullMessage)
    }

    func canLoadMore() -> Bool {
        guard let page = notificationResponse?.data.page,
              let totalPages = notificationResponse?.data.totalPages else { return false }
        return page < totalPages
    }

    func loadMore(completion: @escaping APICompletion) {
        guard let page = notificationResponse?.data.page else { return }
        isLoadingMore = true
        let nextPage = page + 1
        #warning("Need update page param when api handle load more")
        APIRequest.getNotifications(status: noticeType.rawValue, q: "") { [weak self] result in
            guard let this = self else {return}
            switch result {
            case .success(let value):
                let listNotif = this.notificationResponse?.data.rows ?? []
                let newNotifList = value.data.rows
                let sumList = listNotif + newNotifList
                this.notificationResponse = value
                this.notificationResponse?.data.rows = sumList
                var tomorowDate = Date()
                tomorowDate = Calendar.current.date(byAdding: .day, value: 1, to: tomorowDate)!
                if let count = this.notificationResponse?.data.rows.count {
                    for i in 0..<count {
                        this.notificationResponse?.data.rows[i].createdAtDate = i < count / 2 ? Date() : tomorowDate
                    }
                }

                this.prepairData()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
            this.isLoadingMore = false
        }
    }
}
