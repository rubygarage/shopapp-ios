//
//  CountriesUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class CountriesUseCase {
    private let repository: PaymentsRepository

    init(repository: PaymentsRepository) {
        self.repository = repository
    }

    func getCountries(_ callback: @escaping RepoCallback<[Country]>) {
        repository.getCountries(callback: callback)
    }
}
