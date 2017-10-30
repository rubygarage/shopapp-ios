//
//  SplashViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

struct SplashViewModel {
    var isD = Variable<Bool>(false)
    
    var data: Single<(Shop?, [Category]?)> {
        return Single.zip(shop(), categories())
    }
    
    private func shop() -> Single<Shop?> {
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
    
    private func categories() -> Single<[Category]?> {
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
}
