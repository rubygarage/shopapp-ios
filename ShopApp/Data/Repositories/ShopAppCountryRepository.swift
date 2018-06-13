//
//  ShopAppCountryRepository.swift
//  ShopApp
//
//  Created by Mykola Voronin on 6/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class ShopAppCountryRepository: CountryRepository {
    private let api: API

    init(api: API) {
        self.api = api
    }

    func getCountries(callback: @escaping RepoCallback<[Country]>) {
        api.getCountries(callback: callback)
    }
}
