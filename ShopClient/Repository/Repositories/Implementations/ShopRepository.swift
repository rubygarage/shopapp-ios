//
//  ShopRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension RepositoryRepo {
    func getShop(callback: @escaping RepoCallback<ShopObject>) {
        APICore?.getShopInfo(callback: callback)
    }
}
