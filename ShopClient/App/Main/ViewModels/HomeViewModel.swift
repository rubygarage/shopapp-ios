//
//  HomeViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class HomeViewModel: BasePaginationViewModel {
    var data = Variable<(latestProducts: [Product], popularProducts: [Product], articles: [Article])>(latestProducts: [Product](), popularProducts: [Product](), articles: [Article]())
    
    private let articleListUseCase = ArticleListUseCase()
    private let productListUseCase = ProductListUseCase()
    
    override init() {
        super.init()
        
        canLoadMore = false
    }
    
    public func loadData(with disposeBag: DisposeBag) {
        let showHud = data.value.latestProducts.isEmpty && data.value.popularProducts.isEmpty && data.value.articles.isEmpty
        state.onNext(.loading(showHud: showHud))
        Single.zip(productsSingle, popularSingle, articlesSingle).do()
            .subscribe(onSuccess: { [weak self] (latestProducts, popularProducts, articles) in
                if let latestProducts = latestProducts, let popularProducts = popularProducts, let articles = articles {
                    self?.data.value = (latestProducts, popularProducts, articles)
                }
                self?.state.onNext(.content)
            }, onError: { [weak self] (error) in
                let castedError = error as? RepoError
                self?.state.onNext(.error(error: castedError))
            })
            .disposed(by: disposeBag)
    }
    
    private var productsSingle: Single<[Product]?> {
        return Single.create(subscribe: { [weak self] (single) in
            self?.productListUseCase.getLastArrivalProductList { (products, error) in
                if let error = error {
                    single(.error(error))
                }
                if let products = products {
                    single(.success(products))
                }
            }
            return Disposables.create()
        })
    }
    
    private var popularSingle: Single<[Product]?> {
        return Single.create(subscribe: { [weak self] (single) in
            self?.productListUseCase.getPopularProductList { (products, error) in
                if let error = error {
                    single(.error(error))
                }
                if let products = products {
                    single(.success(products))
                }
            }
            return Disposables.create()
        })
    }
    
    private var articlesSingle: Single<[Article]?> {
        return Single.create(subscribe: { [weak self] (single) in
            self?.articleListUseCase.getReverseArticleList { (articles, error) in
                if let error = error {
                    single(.error(error))
                }
                if let articles = articles {
                    single(.success(articles))
                }
            }
            return Disposables.create()
        })
    }
}
