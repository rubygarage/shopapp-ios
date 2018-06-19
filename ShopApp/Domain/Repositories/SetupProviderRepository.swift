//
//  SetupProviderRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

protocol SetupProviderRepository {
    func setupProvider(callback: @escaping RepoCallback<Void>)
}
