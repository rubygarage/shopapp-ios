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
    
    // MARK: - public
    public func loadData() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCartProductList { [weak self] (cartProducts, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let products = cartProducts {
                self?.data.value = products
                self?.state.onNext(.content)
            }
        }
    }
    
    public func remove(cartProduct: CartProduct) {
        state.onNext(.loading(showHud: true))
        Repository.shared.deleteProductFromCart(with: cartProduct.productVariant?.id) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let success = success {
                self?.state.onNext(.content)
                success ? self?.removeFromData(with: cartProduct) : ()
            }
        }
    }
    
    public func update(cartProduct: CartProduct, quantity: Int) {
        state.onNext(.loading(showHud: true))
        Repository.shared.changeCartProductQuantity(with: cartProduct.productVariant?.id, quantity: quantity) { [weak self] (_, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else {
                self?.state.onNext(.content)
                self?.loadData()
            }
        }
    }
    
    public func calculateTotalPrice() -> Float {
        var price: Float = 0
        for cartProduct in data.value {
            price += Float(cartProduct.quantity) * (Float(cartProduct.productVariant?.price ?? String()) ?? 1)
        }
        return price
    }
    
    // MARK: - private
    private func removeFromData(with item: CartProduct) {
        if let index = data.value.index(of: item) {
            data.value.remove(at: index)
        }
    }
}
