//
//  CategoryListViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CategoryListViewModelMock: CategoryListViewModel {
    var isNeedToReturnData = false
    var isReloadDataStarted = false
    var isLoadNextPageStarted = false
    
    override func reloadData() {
        isReloadDataStarted = true
        
        if isNeedToReturnData {
            items.value = [Category()]
        }
    }
    
    override func loadNextPage() {
        isLoadNextPageStarted = true
    }
}
