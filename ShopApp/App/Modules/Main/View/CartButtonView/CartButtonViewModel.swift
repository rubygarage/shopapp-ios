//
//  SearchTitleViewModel.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CartButtonViewModel {
    private let cartProductsUseCase: CartProductsUseCase
    
    var cartItemsCount = PublishSubject<Int>()

    init(cartProductsUseCase: CartProductsUseCase) {
        self.cartProductsUseCase = cartProductsUseCase
    }
    
    func getCartItemsCount() {
        cartProductsUseCase.getCartProducts { [weak self] (products, _) in
            guard let strongSelf = self, let products = products else {
                return
            }
            strongSelf.cartItemsCount.onNext(products.count)
        }
    }
}
