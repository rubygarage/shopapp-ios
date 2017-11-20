//
//  HomeViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class HomeViewModel: BaseViewModel {    
    var data = Variable<(products: [Product], articles: [Article])>(products: [Product](), articles: [Article]())
    
    public func loadData(with disposeBag: DisposeBag) {
        state.onNext(.loading(showHud: true))
        Single.zip(productsSingle, articlesSingle).do()
            .subscribe(onSuccess: { [weak self] (products, articles) in
                if let products = products, let articles = articles {
                    self?.data.value = (products, articles)
                }
                self?.state.onNext(.content)
            }) { [weak self] (error) in
                let castedError = error as! RepoError
                self?.state.onNext(.error(error: castedError))
            }
            .disposed(by: disposeBag)
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
