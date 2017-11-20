//
//  CheckoutViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CheckoutViewModel: BaseViewModel {
    var checkout: Checkout?
    
    public func loadData() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCartProductList { [weak self] (cartProducts, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let products = cartProducts {
                self?.createCheckout(cartProducts: products)
            }
        }
    }
    
    private func createCheckout(cartProducts: [CartProduct]) {
        Repository.shared.getCheckout(cartProducts: cartProducts) { [weak self] (checkout, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let checkout = checkout {
                self?.checkout = checkout
                self?.state.onNext(.content)
            }
        }
    }
}
