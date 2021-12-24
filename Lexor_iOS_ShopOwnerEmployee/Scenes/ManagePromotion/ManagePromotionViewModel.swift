//
//  ManagePromotionViewModel.swift
//  Lexor_iOS_ShopOwnerEmployee
//
//  Created by Le Kim Tuan on 11/10/2021.
//

import UIKit

enum PromotionModelState<T> {
    case initial
    case loading
    case loaded(T)
    case error(Error)
}

protocol ManagePromotionViewModelType {
    var loadPromotionsState: PromotionModelState<[Promotion]> { get }
    var delegate: ManagePromotionViewModelDelegate? { get set }
    var loading: ((Bool) -> Void)? { get set }
    func getListPromotion(promotionName: String, withLoadingIndicator: Bool)
    func updateExpandedPromotion(promotion: PromotionType)
}

protocol ManagePromotionViewModelDelegate: NSObjectProtocol {
    func didLoadPromotions(viewModel: ManagePromotionViewModel)
}

class ManagePromotionViewModel: ManagePromotionViewModelType {
    var loadPromotionsState: PromotionModelState<[Promotion]> = .initial
    var loading: ((Bool) -> Void)?
    weak var delegate: ManagePromotionViewModelDelegate?
    
    func getListPromotion(promotionName: String, withLoadingIndicator: Bool) {
        if withLoadingIndicator {
            loading?(true)
        }
        loadPromotionsState = .loading
        APIRequest.getListPromotion(promotionName: promotionName, completion: { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.loading?(false)
            switch result {
            case .success(let listPromotionResponse):
                strongSelf.loadPromotionsState = .loaded(listPromotionResponse.data.promotions.sorted(by: { $0.startDate < $1.startDate }))
                strongSelf.delegate?.didLoadPromotions(viewModel: strongSelf)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func updateExpandedPromotion(promotion: PromotionType) {
        switch loadPromotionsState {
        case .loaded(let promotions):
            var promotions = promotions
            if let index = promotions.firstIndex(where: { $0.uuid == promotion.uuid }) {
                promotions[index].isExpanded = promotion.isExpanded
                loadPromotionsState = .loaded(promotions)
                delegate?.didLoadPromotions(viewModel: self)
            }
        default:
            break
        }
    }
}
