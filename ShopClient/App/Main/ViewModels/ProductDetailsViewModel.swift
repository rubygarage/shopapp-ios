//
//  ProductDetailsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

typealias SelectedVariant = (variant: ProductVariant?, allOptions: [ProductOption], selectedOptions: [SelectedOption], currency: String)

class ProductDetailsViewModel: BaseViewModel {
    var product = Variable<Product?>(nil)
    var selectedVariant = PublishSubject<SelectedVariant>()
    var quantity = Variable<Int>(1)
    
    var productId: String!
    var productVariant: ProductVariant! {
        didSet {
            productId = productVariant.productId
        }
    }
    var currency: String?
    
    private let addCartProductUseCase = AddCartProductUseCase()
    private let productUseCase = ProductUseCase()
    
    private var productOptions = [ProductOption]()
    private var selectedOptions = [SelectedOption]()
    private var selectedProductVariant: ProductVariant?

    // MARK: - public
    public func loadData() {
        state.onNext(.loading(showHud: true))
        productUseCase.getProduct(with: productId) { [weak self] (product, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let productObject = product {
                self?.setupData(product: productObject)
                self?.product.value = productObject
                self?.state.onNext(.content)
            }
        }
    }
    
    public func selectOption(with name: String, value: String) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        if let index = selectedOptionsNames.index(of: name) {
            selectedOptions[index].value = value
        }
        if let variants = product.value?.variants {
            findVariant(variants: variants)
        }
    }
    
    public var addToCart: Observable<Bool> {
        return Observable.create({ [weak self] event in
            let productQuantity = self?.quantity.value ?? 1
            if let cartProduct = CartProduct(with: self?.product.value, productQuantity: productQuantity, variant: self?.selectedProductVariant) {
                self?.addCartProductUseCase.addCartProduct(cartProduct) { (cartProduct, error) in
                    let success = cartProduct != nil && error == nil
                    event.onNext(success)
                }
            } else {
                event.onNext(false)
            }
            return Disposables.create()
        })
    }
    
    // MARK: - private
    private func setupData(product: Product) {
        if selectedOptions.isEmpty {
            setupSelectedOptions(product: product)
        }
        if selectedProductVariant == nil {
            selectedProductVariant = product.variants?.first
        }
        currency = product.currency
        if let variant = product.variants?.first, let allOptions = product.options, let currency = product.currency {
            let result = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency)
            selectedVariant.onNext(result)
        }
    }
    
    private func setupSelectedOptions(product: Product) {
        if let options = product.options {
            for option in options {
                selectedOptions.append((name: option.name ?? "", value: option.values?.first ?? ""))
            }
        }
    }
    
    private func findVariant(variants: [ProductVariant]) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        let selectedOptionsNValues = selectedOptions.map({ $0.value })
        
        for variant in variants {
            let variantNames = variant.selectedOptions?.map({ $0.name }) ?? [String]()
            let variantValues = variant.selectedOptions?.map({ $0.value }) ?? [String]()
            
            if selectedOptionsNames == variantNames && selectedOptionsNValues == variantValues {
                updateSelectedVariant(variant: variant)
                return
            }
        }
        updateSelectedVariant(variant: nil)
    }
    
    private func updateSelectedVariant(variant: ProductVariant?) {
        selectedProductVariant = variant
        if let allOptions = product.value?.options, let currency = product.value?.currency {
            let result = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency)
            selectedVariant.onNext(result)
        }
    }
}
