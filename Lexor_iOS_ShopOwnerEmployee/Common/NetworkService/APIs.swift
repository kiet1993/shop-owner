//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import Moya
import UIKit

enum APIs {
    case login(username: String, password: String)
    case refreshToken(_ token: String)
    case register(username: String, fullname: String, password: String)
    case logout(token: String)
    case listProduct
    case createProduct(attributeSetId: Int, typeID: String, sku: String,hasOptions: Int,required_options: Int)
    case getListShop(uuid: String)
    case regisFCMToken(fcmToken: String)
    case unRegisFCMToken
    case getListNotifications(status: String, q: String)
    case createBusinessAccount(username: String,
                               firstName: String,
                               lastName: String,
                               email: String,
                               tax: String,
                               gender: Int,
                               status: Int,
                               birthday: String,
                               phone: String)
    case createShop(uuid: String,
                    streetAddress1: String,
                    streetAddress2: String,
                    country: String,
                    city: String,
                    state: String,
                    zipCode: String,
                    phone: String,
                    tax: String,
                    website: String,
                    serviceWebsite: String,
                    isDefaultBillingAddress: Int,
                    isDefaultShippingAddress: Int,
                    isBusinessClosedMoved: Int,
                    isBusinessInsideMallAirport: Int)
    case getListPromotion(promotionName: String)
}

extension APIs: TargetType {

    // MARK: - Base URL
    public var baseURL: URL {
        do {
            switch self {
            case .login,
                 .refreshToken,
                 .logout,
                 .regisFCMToken,
                 .unRegisFCMToken:
                return try "https://inte-lexor-sys-admin.azurewebsites.net".asURL()
            case .createProduct,
                 .listProduct,
                 .getListNotifications,
                 .getListPromotion:
                return try "https://inte-lexor-salon-360-api.azurewebsites.net".asURL()
            case.getListShop, .createBusinessAccount, .createShop:
                return try "https://inte-lexor-admin-api.azurewebsites.net".asURL()
            default:
                return try EndPoint.baseUrl.asURL()
            }
        } catch {
            fatalError("Please set Base URL")
        }
    }

    // MARK: - Path
    public var path: String {
        switch self {
        case .register:
            return "/register"
        case .login:
            return "/auth/login"
        case .refreshToken:
            return "/auth/refreshtoken"
        case .logout:
            return "/auth/logout"
        case .createProduct,
             .listProduct:
            return "/products"
        case .getListShop:
            return "//shop-infor"
        case .regisFCMToken:
            return "/notify/register"
        case .unRegisFCMToken:
            return "/notify/unregister/\(AccountManager.shared.uuidRegistFCMToken ?? "")"
        case .getListNotifications:
            return "/notification"
        case .createBusinessAccount:
            return "/business-accounts"
        case .createShop:
            return "//shop-infor"
        case .getListPromotion:
            return "/gift-card"
        }
    }

    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .register,
             .login,
             .refreshToken,
             .regisFCMToken,
             .logout,
             .createProduct,
             .unRegisFCMToken,
             .createBusinessAccount,
             .createShop:
            return .post
        default:
            return .get
        }
    }

    // MARK: - Task
    public var task: Task {
        switch self {
        case .register:
            return .requestPlain
        case .login(username: let username, password: let password):
            let parameters:[String: Any] = ["username": username, "password": password ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
        case .refreshToken(let token):
            let parameters:[String: Any] = ["token": token]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
        case .logout(token: let token):
            let parameters:[String: Any] = ["token": token]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.httpBody)
        case .listProduct:
            return .requestPlain
        case .createProduct(
                attributeSetId: let attributeSetId,
                typeID: let typeID,
                sku: let sku,
                hasOptions: let hasOptions,
                required_options: let required_options):
            let parameters: [String:Any] = ["attribute_set_id": attributeSetId,
                                            "type_id": typeID,
                                            "sku": sku,
                                            "has_options": hasOptions,
                                            "required_options": required_options
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getListShop(uuid: let uuid):
            let parameters:[String: Any] = ["owner_uuid": uuid]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .regisFCMToken(let fcmToken):
            let parameters: [String:Any] = ["accept_notification": true,
                                            "device_model": UIDevice.modelName,
                                            "device_os_type": "iOS",
                                            "device_os_version": UIDevice.current.systemVersion,
                                            "device_token": fcmToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .unRegisFCMToken:
            return .requestPlain
        case .getListNotifications(status: let status, q: let q):
            let parameters:[String: Any] = ["q": q,"status": status]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .createBusinessAccount(let username, let firstName, let lastName, let email, let tax, let gender, let status, let birthday, let phone):
            let parameters: [String: Any] = ["user_name": username,
                                             "first_name": firstName,
                                             "last_name": lastName,
                                             "email": email,
                                             "tax_vat_number": tax,
                                             "gender": gender,
                                             "status": status,
                                             "birthday": birthday,
                                             "phone": phone
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createShop(let uuid,
                         let streetAddress1,
                         let streetAddress2,
                         let country,
                         let city,
                         let state,
                         let zipCode,
                         let phone,
                         let tax,
                         let website,
                         let serviceWebsite,
                         let isDefaultBillingAddress,
                         let isDefaultShippingAddress,
                         let isBusinessClosedMoved,
                         let isBusinessInsideMallAirport):
            let bodyParameters: [String: Any] = ["street_address1": streetAddress1,
                                                 "street_address2": streetAddress2,
                                                 "city": city,
                                                 "country": country,
                                                 "state": state,
                                                 "zipcode": zipCode,
                                                 "phone": phone,
                                                 "tax": tax,
                                                 "website": website,
                                                 "service_web_address": serviceWebsite,
                                                 "is_default_billing_address": isDefaultBillingAddress,
                                                 "is_default_shipping_address": isDefaultShippingAddress,
                                                 "is_business_closed_moved": isBusinessClosedMoved,
                                                 "is_business_inside_mall_airport": isBusinessInsideMallAirport
            ]
            let urlParammeter: [String: Any] = ["owner_uuid": uuid]
            return .requestCompositeParameters(bodyParameters: bodyParameters, bodyEncoding: JSONEncoding.default, urlParameters: urlParammeter)
        case .getListPromotion(let promotionName):
            if promotionName.isEmpty {
                return .requestPlain
            }
            let parameters: [String: Any] = ["program_name": promotionName]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    func getPostString(params:[String:Any]) -> String {
            var data = [String]()
            for(key, value) in params
            {
                data.append(key + "=\(value)")
            }
            return data.map { String($0) }.joined(separator: "&")
        }

    // MARK: - Validation
    public var validationType: ValidationType {
        return .none
    }

    // MARK: - Sample Data
    public var sampleData: Data {
        return Data()
    }

    // MARK: - Headers
    public var headers: [String: String]? {
        var headers: [String: String] = [:]
        switch self {
        case.login,
            .refreshToken:
            headers[APIKey.accept] = "*/*"
            headers[APIKey.acceptEncoding] = "gzip, deflate, br"
//            headers[APIKey.contentType] = "multipart/form-data"
        case.logout:
            headers[APIKey.authorization] = AccountManager.shared.jwtToken
        case.getListShop,
            .getListNotifications:
            headers[APIKey.authorization] = "Bearer \(AccountManager.shared.accessToken ?? "")"
        default:
            if let token = AccountManager.shared.accessToken, !token.isEmpty {
                headers[APIKey.authorization] = "Bearer " + token
            }
        }
        return headers
    }
}
