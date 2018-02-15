//
//  CountriesUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct CountriesUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func getCountries(_ callback: @escaping RepoCallback<[Country]>) {
        repository.getCountries(callback: callback)
    }
}
