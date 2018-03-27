//
//  ShopRepositoryInterface.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol ShopRepository {
    func getShop(callback: @escaping RepoCallback<Shop>)
}
