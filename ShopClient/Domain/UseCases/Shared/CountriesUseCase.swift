//
//  CountriesUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct CountriesUseCase {
    func getCountries(_ callback: @escaping RepoCallback<[Country]>) {
        Repository.shared.getCountries(callback: callback)
    }
}
