//
//  HomeViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class HomeViewModel: BasePaginationViewModel {
    private let articleListUseCase: ArticleListUseCase
    private let productListUseCase: ProductListUseCase
    private let disposeBag = DisposeBag()

    private var productsSingle: Single<[Product]?> {
        return Single.create(subscribe: { [weak self] single in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            strongSelf.productListUseCase.getLastArrivalProductList { (products, error) in
                if let error = error {
                    single(.error(error))
                } else if let products = products {
                    single(.success(products))
                }
            }
            return Disposables.create()
        })
    }
    private var popularSingle: Single<[Product]?> {
        return Single.create(subscribe: { [weak self] single in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            strongSelf.productListUseCase.getPopularProductList { (products, error) in
                if let error = error {
                    single(.error(error))
                } else if let products = products {
                    single(.success(products))
                }
            }
            return Disposables.create()
        })
    }
    private var articlesSingle: Single<[Article]?> {
        return Single.create(subscribe: { [weak self] single in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            strongSelf.articleListUseCase.getReverseArticleList { (articles, error) in
                if let error = error {
                    single(.error(error))
                } else if let articles = articles {
                    single(.success(articles))
                }
            }
            return Disposables.create()
        })
    }
    
    var data = Variable<(latestProducts: [Product], popularProducts: [Product], articles: [Article])>(latestProducts: [], popularProducts: [], articles: [])
    
    init(articleListUseCase: ArticleListUseCase, productListUseCase: ProductListUseCase) {
        self.articleListUseCase = articleListUseCase
        self.productListUseCase = productListUseCase

        super.init()
        
        self.canLoadMore = false
    }
    
    func loadData() {
        let showHud = data.value.latestProducts.isEmpty && data.value.popularProducts.isEmpty && data.value.articles.isEmpty
        state.onNext(ViewState.make.loading(showHud: showHud))
        Single.zip(productsSingle, popularSingle, articlesSingle)
            .subscribe(onSuccess: { [weak self] (latestProducts, popularProducts, articles) in
                guard let strongSelf = self else {
                    return
                }
                if let latestProducts = latestProducts, let popularProducts = popularProducts, let articles = articles {
                    strongSelf.data.value = (latestProducts, popularProducts, articles)
                }
                strongSelf.state.onNext(.content)
                }, onError: { [weak self] (error) in
                    guard let strongSelf = self else {
                        return
                    }
                    let castedError = error as? RepoError
                    strongSelf.state.onNext(.error(error: castedError))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - BaseViewModel

    override func tryAgain() {
        loadData()
    }
}
