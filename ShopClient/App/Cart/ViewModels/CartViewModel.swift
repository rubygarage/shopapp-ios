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
    
    var data = Variable<[CartProduct]>([])
    
    // MARK: - Private
    
    private func removeFromData(with item: CartProduct) {
        guard let index = data.value.index(of: item) else {
            return
        }
        data.value.remove(at: index)
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
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let cartProducts = cartProducts {
                strongSelf.data.value = cartProducts
                strongSelf.updateSuccessState(with: cartProducts.count)
            }
        }
    }
    
    func removeCardProduct(at index: Int) {
        let cartProduct = data.value[index]
        state.onNext(.loading(showHud: false))
        deleteCartProductUseCase.deleteProductFromCart(productVariantId: cartProduct.productVariant?.id) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success {
                success ? strongSelf.removeFromData(with: cartProduct) : ()
                strongSelf.updateSuccessState(with: self?.data.value.count)
            }
        }
    }
    
    func update(cartProduct: CartProduct, quantity: Int) {
        state.onNext(.loading(showHud: false))
        changeCartProductUseCase.changeCartProductQuantity(productVariantId: cartProduct.productVariant?.id, quantity: quantity) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
                strongSelf.loadData()
            }
        }
    }
    
    func calculateTotalPrice() -> Float {
        let allPrices = data.value.map({ Float($0.quantity) * (Float($0.productVariant?.price ?? "") ?? 1) })
        return allPrices.reduce(0, +)
    }
    
    func productVariant(at index: Int) -> ProductVariant? {
        guard index < data.value.count else {
            return nil
        }
        let product = data.value[index]
        return product.productVariant
    }

    // MARK: - BaseViewModel

    override func tryAgain() {
        loadData()
    }
}
