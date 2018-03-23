//
//  ProductListViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class ProductListViewModelMock: ProductListViewModel {
    var isNeedToReturnData = false
    var isReloadDataStarted = false
    var isLoadNextPageStarted = false
    
    override func reloadData() {
        isReloadDataStarted = true
        if isNeedToReturnData {
            paginationValue = nil
            products.value.removeAll()
            products.value.append(Product())
        }
    }
    
    override func loadNextPage() {
        isLoadNextPageStarted = true
    }
}
