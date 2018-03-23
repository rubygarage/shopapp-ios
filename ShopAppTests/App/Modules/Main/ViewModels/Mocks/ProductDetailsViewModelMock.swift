//
//  ProductDetailsViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class ProductDetailsViewModelMock: ProductDetailsViewModel {
    var isLoadDataStarted = false
    var isNeedToFillProduct = false
    var isLoadRelatedItemsStarted = false
    var isRelatedItemsCountMoreThenConstant = false
    var isNeedToAddProductToCart = false
    var selectedOptionName = ""
    var selectedOptionValue = ""
    
    override func loadData() {
        isLoadDataStarted = true
        currency = "USD"
        
        let item = Product()
        
        if isNeedToFillProduct {
            let image = Image()
            item.images = [image]
            
            item.title = "Product title"
            item.productDescription = "Product description"
        }
        
        product.value = item
        loadRelatedItems()
    }
    
    override var addToCart: Observable<Bool> {
        return Observable.create({ [weak self] event in
            guard let strongSelf = self else {
                return Disposables.create()
            }
            event.onNext(strongSelf.isNeedToAddProductToCart)
            return Disposables.create()
        })
    }
    
    override func selectOption(with name: String, value: String) {
        selectedOptionName = name
        selectedOptionValue = value
    }
    
    func makeSelectedVariant(filled: Bool) {
        var variant: ProductVariant?
        if filled {
            variant = ProductVariant()
            variant?.price = Decimal(floatLiteral: 10)
        }
        let productOption = ProductOption()
        productOption.id = "Product option id"
        productOption.name = "Product option name"
        productOption.values = ["Product option value"]
        let allOptions = [productOption]
        
        let selectedOption = SelectedOption(name: "Product option name", value: "Product option value")
        let selectedOptions = [selectedOption]
        
        let selectedVariantTuple = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency!)
        
        selectedVariant.onNext(selectedVariantTuple)
    }
    
    private func loadRelatedItems() {
        isLoadRelatedItemsStarted = true
        
        var items: [Product] = []
        let itemsCount = isRelatedItemsCountMoreThenConstant ? 15 : 5
        for _ in 1...itemsCount {
            let product = Product()
            product.currency = "USD"
            items.append(product)
        }
        relatedItems.value = items
    }
}
