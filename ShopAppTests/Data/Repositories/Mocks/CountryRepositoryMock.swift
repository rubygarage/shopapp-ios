//
//  CountryRepositoryMock.swift
//  ShopAppTests
//
//  Created by Mykola Voronin on 6/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CountryRepositoryMock: CountryRepository {
    var isNeedToReturnError = false
    var isGetCountriesStarted = false
    
    func getCountries(callback: @escaping ApiCallback<[Country]>) {
        isGetCountriesStarted = true

        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
}
