//
//  ShopUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ShopUseCaseMock: ShopUseCase {
    private let shop = Shop()
    
    override func getShop(_ callback: @escaping (_ shop: Shop) -> Void) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping (_ shop: Shop) -> Void) {
        shop.privacyPolicy = Policy()
        shop.privacyPolicy?.body = "body"
        shop.termsOfService = Policy()
        shop.termsOfService?.body = "body"
        
        callback(shop)
    }
}
