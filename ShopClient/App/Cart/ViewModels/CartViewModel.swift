//
//  CartViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CartViewModel: BaseViewModel {
    private let cartProductListUseCase = CartProductListUseCase()
    private let deleteCartProductUseCase = DeleteCartProductUseCase()
    private let changeCartProductUseCase = ChangeCartProductUseCase()
    
    var data = Variable<[CartProduct]>([CartProduct]())
    
    // MARK: - Private
    
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
    
    // MARK: - Internal
    
    func loadData() {
        state.onNext(.loading(showHud: true))
        cartProductListUseCase.getCartProductList { [weak self] (cartProducts, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let products = cartProducts {
                self?.data.value = products
                self?.updateSuccessState(with: products.count)
            }
        }
    }
    
    func removeCardProduct(at index: Int) {
        let cartProduct = data.value[index]
        state.onNext(.loading(showHud: false))
        deleteCartProductUseCase.deleteProductFromCart(productVariantId: cartProduct.productVariant?.id) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let success = success {
                success ? self?.removeFromData(with: cartProduct) : ()
                self?.updateSuccessState(with: self?.data.value.count)
            }
        }
    }
    
    func update(cartProduct: CartProduct, quantity: Int) {
        state.onNext(.loading(showHud: false))
        changeCartProductUseCase.changeCartProductQuantity(productVariantId: cartProduct.productVariant?.id, quantity: quantity) { [weak self] (_, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else {
                self?.state.onNext(.content)
                self?.loadData()
            }
        }
    }
    
    func calculateTotalPrice() -> Float {
        let allPrices = data.value.map({ Float($0.quantity) * (Float($0.productVariant?.price ?? String()) ?? 1) })
        return allPrices.reduce(0, +)
    }
    
    func productVariant(at index: Int) -> ProductVariant? {
        let product = data.value[index]
        return product.productVariant
    }
}
