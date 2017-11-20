//
//  CheckoutViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutViewModel: BaseViewModel {
    public func createCheckout() {
        Repository.shared.getCartProductList { [weak self] (cartProducts, error) in
            if let error = error {
//                self?.state.
            }
            if let products = cartProducts {
                self?.check(cartProducts: products)
            }
        }
    }
    
    private func check(cartProducts: [CartProduct]) {
        Repository.shared.getCheckout(cartProducts: cartProducts) { (success, error) in
            print()
        }
    }
}
