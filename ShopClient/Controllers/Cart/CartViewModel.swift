//
//  CartViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CartViewModel: BaseViewModel {
    var data = Variable<[CartProduct]>([CartProduct]())
    
    public func loadData() {
        state.onNext((state: .loading, error: nil))
        Repository.shared.getCartProductList { [weak self] (result, error) in
            if let error = error {
                self?.state.onNext((state: .error, error: error))
            }
            if let products = result {
                self?.data.value = products
                self?.state.onNext((state: .content, error: nil))
            }
        }
    }
    
    public func remove(cartProduct: CartProduct) {
        state.onNext((state: .loading, error: nil))
        Repository.shared.deleteProductFromCart(with: cartProduct.productVariant?.id) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext((state: .error, error: error))
            }
            if let success = success {
                self?.state.onNext((state: .content, error: nil))
                success ? self?.removeFromData(with: cartProduct) : ()
            }
        }
    }
    
    private func removeFromData(with item: CartProduct) {
        if let index = data.value.index(of: item) {
            data.value.remove(at: index)
        }
    }
}
