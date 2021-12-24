//
//  RegisterViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Ngoc Hien on 23/05/2021.
//

import Foundation

protocol RegisterViewModelDelegate: NSObjectProtocol {
    func didRegisterFailed(error: Error)
    func didRegisterSuccess()
}

final class RegisterViewModel {
    
    var username = ""
    var password = ""
    var firstName = ""
    var lastName = ""
    var birthday: Date = .today
    var gender = ""
    var emailAddress = ""
    var taxNumber = ""
    var streetAddress1 = ""
    var streetAddress2 = ""
    var country = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var phone = ""
    var fax = ""
    var website = ""
    var serviceWebsite = ""
    var isDefaultBillingAddress: Bool = false
    var isDefaultShippingAddress: Bool = false
    var isBusinessClosedMoved: Bool = false
    var isBusinessInsideMallAirport: Bool = false
    
    var loading: ((Bool) -> Void)?
    weak var delegate: RegisterViewModelDelegate?

    func validateEmpty() -> Bool {
        return !username.isEmpty && !password.isEmpty && !firstName.isEmpty && !lastName.isEmpty && !gender.isEmpty && !emailAddress.isEmpty && !taxNumber.isEmpty && !streetAddress1.isEmpty && !streetAddress2.isEmpty && !country.isEmpty && !city.isEmpty && !state.isEmpty && !zipcode.isEmpty && !phone.isEmpty && !fax.isEmpty && !website.isEmpty && !serviceWebsite.isEmpty
    }
    
    func registerBusinessAccount() {
        loading?(true)
        let gender = self.gender == "Male" ? 1 : 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdayStr = dateFormatter.string(from: birthday)
        APIRequest.createBusinessAccount(username: username,
                                         firstName: firstName,
                                         lastName: lastName,
                                         email: emailAddress,
                                         tax: taxNumber,
                                         gender: gender,
                                         status: 1,
                                         birthday: birthdayStr,
                                         phone: phone) { [weak self] result in
            guard let strongSelf = self else {
                self?.loading?(false)
                return
            }
            switch result {
            case .success(let businessAccountResponse):
                APIRequest.createShop(uuid: businessAccountResponse.data.uuid,
                                      streetAddress1: strongSelf.streetAddress1,
                                      streetAddress2: strongSelf.streetAddress2,
                                      country: strongSelf.country,
                                      city: strongSelf.city,
                                      state: strongSelf.state,
                                      zipCode: strongSelf.zipcode,
                                      phone: strongSelf.phone,
                                      tax: strongSelf.taxNumber,
                                      website: strongSelf.website,
                                      serviceWebsite: strongSelf.serviceWebsite,
                                      isDefaultBillingAddress: strongSelf.isDefaultBillingAddress ? 1 : 0,
                                      isDefaultShippingAddress: strongSelf.isDefaultShippingAddress ? 1 : 0,
                                      isBusinessClosedMoved: strongSelf.isBusinessClosedMoved ? 1 : 0,
                                      isBusinessInsideMallAirport: strongSelf.isBusinessInsideMallAirport ? 1 : 0) { [weak strongSelf] result in
                    strongSelf?.loading?(false)
                    switch result {
                    case .success:
                        strongSelf?.delegate?.didRegisterSuccess()
                    case .failure(let error):
                        strongSelf?.delegate?.didRegisterFailed(error: error)
                    }
                }
            case .failure(let error):
                strongSelf.loading?(false)
                strongSelf.delegate?.didRegisterFailed(error: error)
            }
        }
    }
 }

