//
//  ProductDetailsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

typealias SelectedVariant = (variant: ProductVariant?, allOptions: [ProductOption], selectedOptions: [SelectedOption], currency: String)

class ProductDetailsViewModel: BaseViewModel {
    private let addCartProductUseCase: AddCartProductUseCase
    private let productUseCase: ProductUseCase
    private let productListUseCase: ProductListUseCase
    
    private var productOptions: [ProductOption] = []
    private var selectedOptions: [SelectedOption] = []
    private var selectedProductVariant: ProductVariant?
    
    var productId: String!
    var product = Variable<Product?>(nil)
    var relatedItems = Variable<[Product]>([])
    var selectedVariant = PublishSubject<SelectedVariant>()
    var quantity = Variable<Int>(1)
    var currency: String?
    
    var productVariant: ProductVariant! {
        didSet {
            if let productVariant = productVariant {
                productId = productVariant.productId
            }
        }
    }
    
    var addToCart: Observable<Bool> {
        return Observable.create({ [weak self] event in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            let productQuantity = strongSelf.quantity.value
            guard let cartProduct = CartProduct(with: strongSelf.product.value, productQuantity: productQuantity, variant: strongSelf.selectedProductVariant) else {
                event.onNext(false)
                return Disposables.create()
            }
            strongSelf.addCartProductUseCase.addCartProduct(cartProduct) { (cartProduct, error) in
                let success = cartProduct != nil && error == nil
                event.onNext(success)
            }
            return Disposables.create()
        })
    }

    init(addCartProductUseCase: AddCartProductUseCase, productUseCase: ProductUseCase, productListUseCase: ProductListUseCase) {
        self.addCartProductUseCase = addCartProductUseCase
        self.productUseCase = productUseCase
        self.productListUseCase = productListUseCase
    }

    func loadData() {
        state.onNext(ViewState.make.loading())
        productUseCase.getProduct(with: productId) { [weak self] (product, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let product = product {
                strongSelf.setupData(product: product)
                strongSelf.product.value = product
                if let productVariant = strongSelf.productVariant, let selectedOptions = productVariant.selectedOptions {
                    selectedOptions.forEach { strongSelf.selectOption(with: $0.name, value: $0.value) }
                }
                strongSelf.loadRelatedItems()
            }
        }
    }
    
    func selectOption(with name: String, value: String) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        if let index = selectedOptionsNames.index(of: name) {
            selectedOptions[index].value = value
        }
        if let variants = product.value?.variants {
            findVariant(variants: variants)
        }
    }
    
    private func setupData(product: Product) {
        if selectedOptions.isEmpty {
            setupSelectedOptions(product: product)
        }
        if selectedProductVariant == nil {
            selectedProductVariant = product.variants?.first
        }
        currency = product.currency
        guard let variant = product.variants?.first, let allOptions = product.options, let currency = product.currency else {
            return
        }
        let result = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency)
        selectedVariant.onNext(result)
    }
    
    private func setupSelectedOptions(product: Product) {
        guard let options = product.options else {
            return
        }
        for option in options {
            selectedOptions.append((name: option.name ?? "", value: option.values?.first ?? ""))
        }
    }
    
    private func findVariant(variants: [ProductVariant]) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        let selectedOptionsNValues = selectedOptions.map({ $0.value })
        
        for variant in variants {
            let variantNames = variant.selectedOptions?.map({ $0.name }) ?? []
            let variantValues = variant.selectedOptions?.map({ $0.value }) ?? []
            
            if selectedOptionsNames == variantNames && selectedOptionsNValues == variantValues {
                updateSelectedVariant(variant: variant)
                return
            }
        }
        updateSelectedVariant(variant: nil)
    }
    
    private func updateSelectedVariant(variant: ProductVariant?) {
        selectedProductVariant = variant
        guard let allOptions = product.value?.options, let currency = product.value?.currency else {
            return
        }
        let result = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency)
        selectedVariant.onNext(result)
    }
    
    private func loadRelatedItems() {
        productListUseCase.getProductList(with: nil, sortingValue: SortingValue.type, keyPhrase: product.value?.type, excludePhrase: product.value?.title, reverse: false) { [weak self] (products, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let products = products {
                strongSelf.relatedItems.value = products
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        loadData()
    }
}
