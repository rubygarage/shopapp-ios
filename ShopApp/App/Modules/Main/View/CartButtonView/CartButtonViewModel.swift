//
//  SearchTitleViewModel.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CartButtonViewModel {
    private let cartProductListUseCase: CartProductListUseCase
    
    var cartItemsCount = PublishSubject<Int>()

    init(cartProductListUseCase: CartProductListUseCase) {
        self.cartProductListUseCase = cartProductListUseCase
    }
    
    func getCartItemsCount() {
        cartProductListUseCase.getCartProductList { [weak self] (products, _) in
            guard let strongSelf = self, let products = products else {
                return
            }
            strongSelf.cartItemsCount.onNext(products.count)
        }
    }
}
