//
//  ShopRepositoryMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ShopRepositoryMock: ShopRepository {
    func getShop(callback: @escaping RepoCallback<Shop>) {}
}
