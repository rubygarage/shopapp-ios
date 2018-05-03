//
//  SplashViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import RxSwift

@testable import ShopApp

class SplashViewModelMock: SplashViewModel {
    var isLoadDataStarted = false
    
    override func loadData() {
        isLoadDataStarted = true
    }
}
