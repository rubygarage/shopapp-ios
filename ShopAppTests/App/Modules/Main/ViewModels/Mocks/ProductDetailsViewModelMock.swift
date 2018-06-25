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
        
        product.value = isNeedToFillProduct ? TestHelper.productWithoutAlternativePrice : TestHelper.productWithoutImages
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
    
    override func selectOption(_ option: VariantOption) {
        selectedOptionName = option.name
        selectedOptionValue = option.value
    }
    
    func makeSelectedVariant(filled: Bool) {
        var variant: ProductVariant?
        if filled {
            variant = TestHelper.productVariantWithoutSelectedOptions
        }

        let allOptions = [TestHelper.productOptionWithOneValue]
        let selectedOptions = [TestHelper.variantOption]
        
        let selectedVariantTuple = SelectedVariant(variant: variant, allOptions: allOptions, selectedOptions: selectedOptions, currency: currency!)
        
        selectedVariant.onNext(selectedVariantTuple)
    }
    
    private func loadRelatedItems() {
        isLoadRelatedItemsStarted = true
        
        var items: [Product] = []
        let itemsCount = isRelatedItemsCountMoreThenConstant ? 15 : 5
        for _ in 1...itemsCount {
            items.append(TestHelper.productWithoutAlternativePrice)
        }
        relatedItems.value = items
    }
}
