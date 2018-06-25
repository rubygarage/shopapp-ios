//
//  SetupProviderUseCase.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class SetupProviderUseCase {
    private let repository: SetupProviderRepository
    
    init(repository: SetupProviderRepository) {
        self.repository = repository
    }
    
    func setupProvider(callback: @escaping ApiCallback<Void>) {
        repository.setupProvider(callback: callback)
    }
}
