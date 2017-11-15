//
//  HomeViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class HomeViewModel: BaseViewModel {
    var lastArrivalsProducts = Variable<[Product]>([Product]())
    var newInBlogArticles = Variable<[Article]>([Article]())
    
    var data: Single<([Product]?, [Article]?)> {
        state.onNext(.loading)
        return Single.zip(productsSingle, articlesSingle).do(onNext: { [weak self] (products, articles) in
            if let products = products {
                self?.lastArrivalsProducts.value = products
            }
            if let articles = articles {
                self?.newInBlogArticles.value = articles
            }
            self?.state.onNext(.content)
        }, onError: { [weak self] (error) in
            self?.state.onNext(.error(RepoError(with: error)))
        })
    }
    
    private var productsSingle: Single<[Product]?> {
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
    
    private var articlesSingle: Single<[Article]?> {
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
