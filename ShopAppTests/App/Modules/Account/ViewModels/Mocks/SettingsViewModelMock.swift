//
//  SettingsViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class SettingsViewModelMock: SettingsViewModel {
    var isNeedToReturnData = true
    var isCustomerLoadingStarted = false
    var promo = false
    
    override func loadCustomer() {
        isCustomerLoadingStarted = true
        
        if isNeedToReturnData {
            customer.value = Customer()
        } else {
            customer.value = nil
        }
    }
    
    override func setPromo(_ value: Bool) {
        promo = value
    }
}
