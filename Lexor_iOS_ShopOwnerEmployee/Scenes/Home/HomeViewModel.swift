//
//  HomeViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Duy Tran N. on 5/26/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit.UIImage

final class HomeViewModel {

    var listProductResponse: ListShopResponse?
    
    static var homeItems: [HomeGroup] {
        guard let userInfo = AccountManager.shared.currentUser else { return []}
        switch userInfo.userType {
        case .shopOwner:
            return [.marketing,
                    .inventory,
                    .staff,
                    .businessManagement
            ]
        case .technician:
            return [.myWorkplace]
        }
    }

    enum HomeGroup: CaseIterable {
        case marketing
        case inventory
        case staff
        case businessManagement
        case myWorkplace

        var categoryName: String {
            switch self {
            case .marketing:
                return "Marketing"
            case .inventory:
                return "Inventory"
            case .staff:
                return "Staff"
            case .businessManagement:
                return "Business Management"
            case .myWorkplace:
                return "My Workplace"
            }
        }

        var items: [ItemInfo] {
            switch self {
            case .marketing:
                return [.reviewRating,
                        .joinMarketingActivities,
                        .loyaltyReward,
                        .giftCardCoupon]
            case .inventory:
                return [.virtualProduct,
                        .bundleProduct]
            case .staff:
                return [.create,
                        .invite]
            case .businessManagement:
                return [.saleOrder,
                        .bizExpenseManagement,
                        .shopGroup,
                        .workSchedule]
            case .myWorkplace:
                return [.appointmentBooking,
                        .myExpenseManagement,
                        .assignTask]
            }
        }
    }

    enum ItemInfo: CaseIterable {

        /// `Marketing`
        case reviewRating
        case joinMarketingActivities
        case loyaltyReward
        case giftCardCoupon

        /// `Inventory`
        case virtualProduct
        case bundleProduct

        /// `Staff`
        case create
        case invite

        /// `Business Management`
        case saleOrder
        case bizExpenseManagement
        case shopGroup
        case workSchedule

        /// `My Workplace`
        case appointmentBooking
        case myExpenseManagement
        case assignTask

        var title: String {
            switch self {
            case .reviewRating: return "Review Rating"
            case .joinMarketingActivities: return "Join Marketing Activities"
            case .loyaltyReward: return "Loyalty/Reward"
            case .giftCardCoupon: return "Gift card/Coupon"
            case .virtualProduct: return "Virtual Product"
            case .bundleProduct: return "Bundle Product"
            case .create: return "Create"
            case .invite: return "Invite"
            case .saleOrder: return "Sale Order"
            case .bizExpenseManagement: return "Expense Management"
            case .shopGroup: return "Shop Group"
            case .workSchedule: return "Work Schedule"
            case .appointmentBooking: return "Appointment & Booking"
            case .myExpenseManagement: return "Expense Management"
            case .assignTask: return "Assign Task"
            }
        }

        var iconImage: UIImage {
            switch self {
            case .reviewRating: return #imageLiteral(resourceName: "ic-rating")
            case .joinMarketingActivities: return #imageLiteral(resourceName: "ic-marketing")
            case .loyaltyReward: return #imageLiteral(resourceName: "ic-loyalty-reward")
            case .giftCardCoupon: return #imageLiteral(resourceName: "ic-gift-card")
            case .virtualProduct: return #imageLiteral(resourceName: "ic-virtual")
            case .bundleProduct: return #imageLiteral(resourceName: "ic-bundle-product")
            case .create: return #imageLiteral(resourceName: "ic-create-staff")
            case .invite: return #imageLiteral(resourceName: "ic-invite-staff")
            case .saleOrder: return #imageLiteral(resourceName: "ic-sale-order")
            case .bizExpenseManagement: return #imageLiteral(resourceName: "ic-biz-expense-manager")
            case .shopGroup: return #imageLiteral(resourceName: "ic-shop-group")
            case .workSchedule: return #imageLiteral(resourceName: "ic-schedule")
            case .appointmentBooking: return #imageLiteral(resourceName: "ic-appointment-booking")
            case .myExpenseManagement: return #imageLiteral(resourceName: "ic-my-expense-manager")
            case .assignTask: return #imageLiteral(resourceName: "ic-assign-task")
            }
        }
    }
}

extension HomeViewModel {

    func getListShop(completion: @escaping APICompletion) {
        guard let uuid = AccountManager.shared.currentUser?.userid else { return }
        APIRequest.getListShop(ownerUUID: uuid) { result in
            switch result {
            case .success(let value):
                self.listProductResponse = value
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
