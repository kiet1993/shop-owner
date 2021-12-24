//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import Moya
import Alamofire
import UIKit

extension MoyaError {
    var underlyingEror: Error {
        switch self {
        case .encodableMapping: return self
        case .imageMapping: return self
        case .jsonMapping: return self
        case .objectMapping: return self
        case .parameterEncoding: return self
        case .requestMapping: return self
        case .statusCode: return self
        case .stringMapping: return self
        case .underlying(let error, _): return error
        }
    }
}

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

private let apiProvider = MoyaProvider<APIs>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                                                                logOptions: [.requestMethod,
                                                                                                             .requestHeaders,
                                                                                                             .requestBody,
                                                                                                             .formatRequestAscURL,
                                                                                                             .successResponseBody,
                                                                                                             .errorResponseBody]))])

class APIRequest {
    @discardableResult
    private static func request<T: Decodable>(targetAPI: APIs,
                                              completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)
        return apiProvider.request(targetAPI) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        if response.statusCode == 200 {
                            let value = try jsonDecoder.decode(T.self, from: response.data)
                            completion(.success(value))
                        } else if response.statusCode == 401 {
                            if let jwtToken = AccountManager.shared.jwtToken {
                                APIRequest.refreshToken(jwtToken) { refreshTokenResult in
                                    switch refreshTokenResult {
                                    case .success(let data):
                                        AccountManager.shared.accessToken = data.token
                                        APIRequest.request(targetAPI: targetAPI, completion: completion)
                                    case .failure:
                                        let error: NSError = NSError(code: response.statusCode, message: "Refresh token failed")
                                        completion(.failure(error))
                                    }
                                }
                            } else {
                                let error: NSError = NSError(code: response.statusCode, message: "Token expired")
                                completion(.failure(error))
                            }
                        } else if response.statusCode == 403 {
                            if targetAPI.path == APIs.logout(token: "").path {
                                let error: NSError = NSError(code: response.statusCode, message: "Authentication failed")
                                completion(.failure(error))
                            } else if let jwtToken = AccountManager.shared.jwtToken {
                                APIRequest.refreshToken(jwtToken) { refreshTokenResult in
                                    switch refreshTokenResult {
                                    case .success(let data):
                                        AccountManager.shared.accessToken = data.token
                                        APIRequest.request(targetAPI: targetAPI, completion: completion)
                                    case .failure:
                                        let error: NSError = NSError(code: response.statusCode, message: "Refresh token failed")
                                        completion(.failure(error))
                                    }
                                }
                            } else {
                                let error: NSError = NSError(code: response.statusCode, message: "Authentication failed")
                                completion(.failure(error))
                            }
                        } else {
                            let value = try jsonDecoder.decode(ErrorResponse.self, from: response.data)
                            let error: NSError = NSError(code: response.statusCode, message: value.data)
                            completion(.failure(error))
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    private static func requestAdmin<T: Decodable>(targetAPI: APIs,
                                              using decoder: JSONDecoder = JSONDecoder(),
                                              completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)
        return apiProvider.request(targetAPI) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    do {
                        if response.statusCode == 200 {
                            let value = try  jsonDecoder.decode(T.self, from: response.data)
                            completion(.success(value))
                        } else {
                            if response.statusCode == 401 {
                                if let jwtToken = AccountManager.shared.jwtToken {
                                    APIRequest.refreshToken(jwtToken) { refreshTokenResult in
                                        switch refreshTokenResult {
                                        case .success(let data):
                                            AccountManager.shared.accessToken = data.token
                                            APIRequest.requestAdmin(targetAPI: targetAPI, using: jsonDecoder, completion: completion)
                                        case .failure:
                                            let error: NSError = NSError(code: response.statusCode, message: "Refresh token failed")
                                            completion(.failure(error))
                                        }
                                    }
                                } else {
                                    let error: NSError = NSError(code: response.statusCode, message: "Token expired")
                                    completion(.failure(error))
                                }
                            } else {
                                let value = try jsonDecoder.decode(ErrorResponse.self, from: response.data)
                                let error: NSError = NSError(code: response.statusCode, message: value.data)
                                completion(.failure(error))
                            }
                        }
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

struct ApiResponse: Decodable {
    let data: Data
    let statusCode: Int
}

struct APIError: Decodable {
    let message: String
}

extension APIRequest {
    // TODO: Define for each requests API of App
    static func login(username: String, password: String, completion: @escaping(Swift.Result<LoginResult, Error>) -> Void) {
        APIRequest.requestAdmin(targetAPI: .login(username: username, password: password), completion: completion)
    }
    
    static func refreshToken(_ jwtToken: String, completion: @escaping(Swift.Result<LoginResult, Error>) -> Void) {
        APIRequest.request(targetAPI: .refreshToken(jwtToken), completion: completion)
    }

    static func logout(token: String, completion: @escaping(Swift.Result<String, Error>) -> Void) {
        APIRequest.request(targetAPI: .logout(token: token), completion: completion)
    }

    static func listProduct(completion: @escaping(Swift.Result<ResponeProduct, Error>) -> Void) {
        // Hard value
        APIRequest.request(targetAPI: .listProduct, completion: completion)
    }

    static func createProduct(sku: String, completion: @escaping(Swift.Result<CreateProduct, Error>) -> Void) {
        APIRequest.request(targetAPI: .createProduct(attributeSetId: 1, typeID: "simple", sku: sku, hasOptions: 0, required_options: 1), completion: completion)
    }

    static func getListShop(ownerUUID: String, completion: @escaping(Swift.Result<ListShopResponse, Error>) -> Void) {
        APIRequest.request(targetAPI: .getListShop(uuid: ownerUUID), completion: completion)
    }
    
    static func regisFCMToken(fcmToken: String, completion: @escaping(Result<RegisterTokenResponse, Error>) -> Void) {
        APIRequest.request(targetAPI: .regisFCMToken(fcmToken: fcmToken), completion: completion)
    }
    
    static func unRegisFCMToken(completion: @escaping(Result<String, Error>) -> Void) {
        APIRequest.request(targetAPI: .unRegisFCMToken, completion: completion)
    }

    static func getNotifications(status: String, q: String, completion: @escaping(Swift.Result<NotificationResponse, Error>) -> Void) {
        APIRequest.request(targetAPI: .getListNotifications(status: status, q: status), completion: completion)
    }
    
    static func createBusinessAccount(username: String,
                                      firstName: String,
                                      lastName: String,
                                      email: String,
                                      tax: String,
                                      gender: Int,
                                      status: Int,
                                      birthday: String,
                                      phone: String,
                                      completion: @escaping(Result<BusinessAccountResponse, Error>) -> Void) {
        APIRequest.request(targetAPI: .createBusinessAccount(username: username,
                                                             firstName: firstName,
                                                             lastName: lastName,
                                                             email: email,
                                                             tax: tax,
                                                             gender: gender,
                                                             status: status,
                                                             birthday: birthday,
                                                             phone: phone),
                           completion: completion)
    }
    
    static func createShop(uuid: String,
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
                           isBusinessInsideMallAirport: Int,
                           completion: @escaping(Result<CreateShopResponse, Error>) -> Void) {
        APIRequest.request(targetAPI: .createShop(uuid: uuid,
                                                  streetAddress1: streetAddress1,
                                                  streetAddress2: streetAddress2,
                                                  country: country,
                                                  city: city,
                                                  state: state,
                                                  zipCode: zipCode,
                                                  phone: phone,
                                                  tax: tax,
                                                  website: website,
                                                  serviceWebsite: serviceWebsite,
                                                  isDefaultBillingAddress: isDefaultBillingAddress,
                                                  isDefaultShippingAddress: isDefaultShippingAddress,
                                                  isBusinessClosedMoved: isBusinessClosedMoved,
                                                  isBusinessInsideMallAirport: isBusinessInsideMallAirport),
                           completion: completion)
    }
    
    static func getListPromotion(promotionName: String, completion: @escaping(Result<ListPromotionResponse, Error>) -> Void) {
        APIRequest.request(targetAPI: .getListPromotion(promotionName: promotionName), completion: completion)
    }
}
