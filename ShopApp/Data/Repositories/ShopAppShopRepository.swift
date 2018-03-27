//
//  ShopAppShopRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

public class ShopAppShopRepository: ShopRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    public func getShop(callback: @escaping RepoCallback<Shop>) {
        api.getShopInfo(callback: callback)
    }
}
