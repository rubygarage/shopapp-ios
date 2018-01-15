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
                self?.updateSuccessState(with: products.count)
            }
        }
    }
    
    public func removeCardProduct(at index: Int) {
        let cartProduct = data.value[index]
        state.onNext(.loading(showHud: false))
        Repository.shared.deleteProductFromCart(with: cartProduct.productVariant?.id) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let success = success {
                success ? self?.removeFromData(with: cartProduct) : ()
                self?.updateSuccessState(with: self?.data.value.count)
            }
        }
    }
    
    public func update(cartProduct: CartProduct, quantity: Int) {
        state.onNext(.loading(showHud: false))
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
        let allPrices = data.value.map({ Float($0.quantity) * (Float($0.productVariant?.price ?? String()) ?? 1) })
        return allPrices.reduce(0, +)
    }
    
    // MARK: - private
    private func removeFromData(with item: CartProduct) {
        if let index = data.value.index(of: item) {
            data.value.remove(at: index)
        }
    }
    
    private func updateSuccessState(with itemsCount: Int?) {
        if let itemsCount = itemsCount, itemsCount > 0 {
            state.onNext(.content)
        } else {
            state.onNext(.empty)
        }
    }
}
