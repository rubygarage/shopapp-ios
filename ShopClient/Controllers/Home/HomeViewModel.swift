//
//  HomeViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

struct HomeViewModel {
    var data: Single<([Product]?, [Article]?)> {
        return Single.zip(lastArrivalsProducts, articles)
    }
    
    private var lastArrivalsProducts: Single<[Product]?> {
        return Single.create(subscribe: { (single) in
            Repository.shared.getProductList(sortBy: SortingValue.createdAt, reverse: true, callback: { (products, error) in
                if let error = error {
                    single(.error(error))
                }
                if let products = products {
                    single(.success(products))
                }
            })
            return Disposables.create()
        })
    }
    
    private var articles: Single<[Article]?> {
        return Single.create(subscribe: { (single) in
            Repository.shared.getArticleList(reverse: true, callback: { (articles, error) in
                if let error = error {
                    single(.error(error))
                }
                if let articles = articles {
                    single(.success(articles))
                }
            })
            return Disposables.create()
        })
    }
}
