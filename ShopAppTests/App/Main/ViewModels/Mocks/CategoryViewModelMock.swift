//
//  CategoryViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CategoryViewModelMock: CategoryViewModel {
    var isNeedToReturnData = false
    var isReloadDataStarted = false
    var isLoadNextPageStarted = false
    var isResultCleared = false
    
    override func reloadData() {
        isReloadDataStarted = true
        
        if isNeedToReturnData {
            var products: [Product] = []
            
            for _ in 1...20 {
                let product = Product()
                product.currency = "USD"
                products.append(product)
            }
            
            self.products.value = products
        }
    }
    
    override func loadNextPage() {
        isLoadNextPageStarted = true
    }
    
    override func clearResult() {
        isResultCleared = true
    }
}
