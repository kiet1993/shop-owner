//
//  NotificationCellViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Hien Ngoc on 05/08/2021.
//

import Foundation

class NotificationCellViewModel {
    var title: String
    var date: String
    var discription: String
    
    init(title: String,date: String, discription: String ) {
        self.title = title
        self.date = date
        self.discription = discription
    }
}
