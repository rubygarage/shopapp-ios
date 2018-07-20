//
//  CountriesUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class CountriesUseCase {
    private let repository: CountryRepository

    init(repository: CountryRepository) {
        self.repository = repository
    }

    func getCountries(_ callback: @escaping ApiCallback<[Country]>) {
        repository.getCountries(callback: callback)
    }
}
