//
//  SearchTitleViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CartButtonViewModel {
    var cartItemsCount = PublishSubject<Int>()
    
    private let cartProductListUseCase = CartProductListUseCase()
    
    public func getCartItemsCount() {
        cartProductListUseCase.getCartProductList { [weak self] (products, _) in
            if let products = products {
                self?.cartItemsCount.onNext(products.count)
            }
        }
    }
}
