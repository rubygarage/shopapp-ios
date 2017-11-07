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
    
    var productId: String!
    var productOptions = [ProductOption]()
    var selectedOptions = [SelectedOption]()
    var currency: String?
    
    private func setupData(product: Product) {
        if selectedOptions.count == 0 {
            setupSelectedOptions(product: product)
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
                selectedOptions.append((name: option.name ?? String(), value: option.values?.first ?? String()))
            }
        }
    }
    
    public func loadData() {
        state.onNext((state: .loading, error: nil))
        Repository.shared.getProduct(id: productId) { [weak self] (product, error) in
            if let error = error {
                self?.state.onNext((state: .error, error: error))
            }
            if let productObject = product {
                self?.setupData(product: productObject)
                self?.product.value = productObject
                self?.state.onNext((state: .content, error: nil))
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
    
    private func findVariant(variants: [ProductVariant]) {
        let selectedOptionsNames = selectedOptions.map({ $0.name })
        let selectedOptionsNValues = selectedOptions.map({ $0.value })
        
        for variant in variants {
            let variantNames = variant.selectedOptions?.map({ $0.name }) ?? [String()]
            let variantValues = variant.selectedOptions?.map({ $0.value }) ?? [String()]
            
            if selectedOptionsNames == variantNames && selectedOptionsNValues == variantValues {
                updateSelectedVariant(variant: variant)
                return
            }
        }
        updateSelectedVariant(variant: nil)
    }
    
    private func updateSelectedVariant(variant: ProductVariant?) {
        if let allOptions = product.value?.options, let currency = product.value?.currency {
            let result = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency)
            selectedVariant.onNext(result)
        }
    }
}
