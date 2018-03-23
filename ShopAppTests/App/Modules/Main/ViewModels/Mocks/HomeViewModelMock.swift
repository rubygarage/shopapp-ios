//
//  HomeViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class HomeViewModelMock: HomeViewModel {
    var isDataLoadingStarted = false
    var isNeedsToReturnError = false
    
    override func loadData() {
        isDataLoadingStarted = true
        if !isNeedsToReturnError {
            data.value = ([Product()], [Product()], [Article()])
        }
    }
}

