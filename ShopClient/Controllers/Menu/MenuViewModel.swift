//
//  MenuViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

struct MenuViewModel {
    var data: Single<(Shop?, [Category]?)> {
        return Single.zip(shop, categories)
    }
    
    private var shop: Single<Shop?> {
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
    
    private var categories: Single<[Category]?> {
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
