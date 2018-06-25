//
//  ShopAppSetupProviderRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class ShopAppSetupProviderRepository: SetupProviderRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func setupProvider(callback: @escaping ApiCallback<Void>) {
        api.setupProvider(callback: callback)
    }
}
