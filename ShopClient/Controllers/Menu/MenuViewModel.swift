//
//  MenuViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class MenuViewModel: BaseViewModel {
    var categories = Variable<[Category]>([Category]())
    var policies = Variable<[Policy]>([Policy]())
    
    var data: Single<(Shop?, [Category]?)> {
        state.onNext((.loading, nil))
        return Single.zip(shopSingle, categoriesSingle).do(onNext: { [weak self] (shop, categories) in
            self?.processResponse(with: shop, categoriesItems: categories)
            self?.state.onNext((.content, nil))
            }, onError: { [weak self] (error) in
                self?.state.onNext((.error, (RepoError(with: error))))
        })
    }
    
    private var shopSingle: Single<Shop?> {
        return Single.create(subscribe: { (single) in
            Repository.shared.getShop(callback: { (shop, error) in
                if let error = error {
                    single(.error(error))
                }
                if let shop = shop {
                    single(.success(shop))
                }
            })
            return Disposables.create()
        })
    }
    
    private var categoriesSingle: Single<[Category]?> {
        return Single.create(subscribe: { (single) in
            Repository.shared.getCategoryList(callback: { (categories, error) in
                if let error = error {
                    single(.error(error))
                }
                if let categories = categories {
                    single(.success(categories))
                }
            })
            return Disposables.create()
        })
    }
    
    private func processResponse(with shopItem: Shop?, categoriesItems: [Category]?) {
        if let privacyPolicy = shopItem?.privacyPolicy {
            policies.value.append(privacyPolicy)
        }
        if let refundPolicy = shopItem?.refundPolicy {
            policies.value.append(refundPolicy)
        }
        if let termsOfService = shopItem?.termsOfService {
            policies.value.append(termsOfService)
        }
        if let categoriesItems = categoriesItems {
            categories.value = categoriesItems
        }
    }
}
