//
//  ShopRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension Repository {
    func getShop(callback: @escaping RepoCallback<Shop>) {
        APICore?.getShopInfo(callback: callback)
    }
}
